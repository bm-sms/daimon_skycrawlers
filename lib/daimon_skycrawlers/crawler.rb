require "uri"

require "daimon_skycrawlers"
require "daimon_skycrawlers/version"
require "daimon_skycrawlers/configure_songkick_queue"
require "daimon_skycrawlers/url_consumer"
require "daimon_skycrawlers/storage"

require "faraday"

module DaimonSkycrawlers
  class Crawler
    class << self
      def run(process_name: "daimon-skycrawler:url")
        SongkickQueue::Worker.new(process_name, [URLConsumer]).run
      end

      def enqueue_url(url, depth: 3, interval: 1)
        SongkickQueue.publish("daimon-skycrawler.url", url: url, depth: depth, interval: interval)
      end
    end

    attr_writer :storage

    def initialize(base_url, options = {})
      @base_url = base_url
      @options = options
    end

    def setup_connection(options = {})
      @connection = Faraday.new(@base_url, options) do |faraday|
        yield faraday
      end
    end

    def storage
      @storage ||= Storage::RDB.new
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

    def enqueue_next_urls(urls, depth: 3, interval: 1)
      return if depth <= 0

      urls.each do |url|
        self.class.enqueue_url(url, depth: depth, interval: interval)
      end
    end
  end
end
