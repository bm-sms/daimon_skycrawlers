require "uri"
require "faraday"

require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/config"
require "daimon_skycrawlers/storage"
require "daimon_skycrawlers/processor"

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

      #
      # @param [String] Base URL for crawler
      # @param [Hash] options for Faraday
      #
      def initialize(base_url = nil, options = {})
        super()
        @base_url = base_url
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
        @connection = Faraday.new(@base_url, @options.merge(options)) do |faraday|
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
        @connection ||= Faraday.new(@base_url, @options)
      end

      def fetch(path, params = {}, **kw)
        raise NotImplementedError, "Must implement this method in subclass"
      end

      def get(path, params = {})
        @connection.get(path, params)
      end

      def post(path, params = {})
        @connection.post(path, params)
      end

      def n_processed_urls
        @n_processed_urls
      end

      private

      def schedule_to_process(url, message = {})
        DaimonSkycrawlers::Processor.enqueue_http_response(url, message)
      end
    end
  end
end
