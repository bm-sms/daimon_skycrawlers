require 'uri'

require 'daimon_skycrawlers'
require 'daimon_skycrawlers/version'
require 'daimon_skycrawlers/configure_songkick_queue'
require 'daimon_skycrawlers/url_consumer'

require 'faraday'
require 'nokogiri'

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

    def initialize(base_url, options = {})
      @base_url = base_url
    end

    def setup_connection(options = {})
      @connection = Faraday.new(@base_url, options) do |faraday|
        yield faraday
      end
    end

    def append_filter(filter = nil, &block)
      if block_given?
        @filters << block
      else
        @filters << filter
      end
    end

    # TODO Support POST when we need
    # TODO `params` should be a part of `path`. such as `path == "/hoi?hi=yoyo"`.
    def fetch(path, params = {}, depth: 3)
      @connection ||= Faraday.new(@base_url)
      response = get(path)

      url = @connection.url_prefix + path

      data = [url.to_s, response.headers, response.body]

      yield(*data) if block_given?

      schedule_to_process(*data)

      urls = retrieve_links(response.body)

      enqueue_next_urls(urls, depth - 1)
    end

    def get(path, params = {})
      @connection.get(path, params)
    end

    def post(path, params = {})
      @connection.post(path, params)
    end

    private

    def schedule_to_process(url, headers, body)
      DaimonSkycrawlers::Processor.enqueue_http_response(url, headers, body)
    end

    def retrieve_links(html)
      links = []
      html = Nokogiri::HTML(html.force_encoding("utf-8"))
      html.search("a").each do |element|
        links << element["href"]
      end
      apply_filters(links)
    end

    def apply_filters(links)
      @filters.each do |filter|
        links = links.select do |link|
          filter.call(link)
        end
      end
      links
    end

    def enqueue_next_urls(urls, depth)
      return if depth <= 0

      urls.each do |url|
        self.class.enqueue_url(url, depth)
      end
    end
  end
end
