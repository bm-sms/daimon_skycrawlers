require 'uri'

require 'daimon_skycrawlers'
require 'daimon_skycrawlers/version'
require 'daimon_skycrawlers/configure_songkick_queue'
require 'daimon_skycrawlers/url_consumer'
require 'daimon_skycrawlers/storage'
require 'daimon_skycrawlers/parser'

require 'faraday'

module DaimonSkycrawlers
  class Crawler
    class << self
      def run(process_name: 'daimon-skycrawler:url')
        SongkickQueue::Worker.new(process_name, [URLConsumer]).run
      end

      def enqueue_url(url, depth)
        SongkickQueue.publish('daimon-skycrawler.url', url: url, depth: depth)
      end
    end

    attr_writer :storage
    attr_writer :parser

    def initialize(base_url, options = {})
      @base_url = base_url
      @options = options
      @filters = []
    end

    def setup_connection(options = {})
      @connection = Faraday.new(@base_url, options) do |faraday|
        yield faraday
      end
    end

    def configure_parser
      yield parser
    end

    def append_filter(filter = nil, &block)
      if parser.respond_to?(__callee__)
        parser.append_filter(filter, &block)
      else
        # TODO Use suitable exception
        raise "#{parser.class} cannot receive #{__callee__}"
      end
    end

    def storage
      @storage ||= Storage::RDB.new
    end

    def parser
      @parser ||= Parser::Default.new
    end

    # TODO Support POST when we need
    # TODO `params` should be a part of `path`. such as `path == "/hoi?hi=yoyo"`.
    def fetch(path, params = {}, depth: 3)
      @connection ||= Faraday.new(@base_url)
      response = get(path)

      url = @connection.url_prefix + path

      data = [url.to_s, response.headers, response.body]

      yield(*data) if block_given?

      storage.save(*data)

      schedule_to_process(url.to_s)

      parser.parse(response.body)
      urls = parser.links

      enqueue_next_urls(urls, depth - 1)
    end

    def get(path, params = {})
      @connection.get(path, params)
    end

    def post(path, params = {})
      @connection.post(path, params)
    end

    private

    def schedule_to_process(url)
      DaimonSkycrawlers::Processor.enqueue_http_response(url)
    end

    def enqueue_next_urls(urls, depth)
      return if depth <= 0

      urls.each do |url|
        self.class.enqueue_url(url, depth)
      end
    end
  end
end
