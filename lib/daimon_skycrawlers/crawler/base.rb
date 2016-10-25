require "uri"
require "faraday"

require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/config"
require "daimon_skycrawlers/storage"
require "daimon_skycrawlers/processor"
require "daimon_skycrawlers/filter/update_checker"
require "daimon_skycrawlers/filter/robots_txt_checker"

module DaimonSkycrawlers
  module Crawler
    #
    # The base class of crawler
    #
    class Base
      include DaimonSkycrawlers::LoggerMixin
      include DaimonSkycrawlers::ConfigMixin

      # @!attribute [w] storage
      #   Set storage to crawler instance.
      #   @return [void]
      attr_writer :storage

      # @!attribute [r] n_processed_urls
      #   The number of processed URLs.
      #   @return [Integer]
      attr_reader :n_processed_urls

      #
      # @param [String] Base URL for crawler
      # @param [Hash] options for Faraday
      #
      def initialize(base_url = nil, faraday_options: {}, options: {})
        super()
        @base_url = base_url
        @faraday_options = faraday_options
        @options = options
        @prepare = ->(connection) {}
        @skipped = false
        @n_processed_urls = 0
      end

      #
      # Set up connection
      #
      # @param [Hash] options for Faraday
      # @yield [faraday]
      # @yieldparam faraday [Faraday]
      #
      def setup_connection(options = {})
        merged_options = @faraday_options.merge(options)
        faraday_options = merged_options.empty? ? nil : merged_options
        @connection = Faraday.new(@base_url, faraday_options) do |faraday|
          yield faraday
        end
      end

      #
      # Call this method before DaimonSkycrawlers.register_crawler
      # For example, you can login before fetch URL
      #
      def prepare(&block)
        @prepare = block
      end

      #
      # Retrieve storage instance
      #
      def storage
        @storage ||= Storage::RDB.new
      end

      def skipped?
        @skipped
      end

      def connection
        @connection ||= Faraday.new(@base_url, @faraday_options)
      end

      def process(message, &block)
        url = message.delete(:url)

        @skipped = false
        @n_processed_urls += 1
        # url can be a path
        url = connection.url_prefix + url

        apply_filters(url)

        unless skipped?
          @prepare.call(connection)
          fetch(url, message, &block)
        end
      end

      def fetch(path, message = {})
        raise NotImplementedError, "Must implement this method in subclass"
      end

      def get(path, params = {})
        @connection.get(path, params)
      end

      def post(path, params = {})
        @connection.post(path, params)
      end

      private

      def apply_filters(url)
        if @options[:obey_robots_txt]
          robots_txt_checker = DaimonSkycrawlers::Filter::RobotsTxtChecker.new(base_url: @base_url)
          unless robots_txt_checker.allowed?(url)
            skip(url)
            return
          end
        end
        update_checker = DaimonSkycrawlers::Filter::UpdateChecker.new(storage: storage)
        unless update_checker.updated?(url.to_s, connection: connection)
          skip(url)
          return
        end
      end

      def skip(url)
        log.info("Skip #{url}")
        @skipped = true
        schedule_to_process(url.to_s, heartbeat: true)
      end

      def schedule_to_process(url, message = {})
        DaimonSkycrawlers::Processor.enqueue_http_response(url, message)
      end
    end
  end
end
