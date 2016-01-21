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
      def run(process_name: 'daimon-skycrawler')
        SongkickQueue::Worker.new(process_name, [URLConsumer]).run
      end

      def enqueue_url(url)
        SongkickQueue.publish 'daimon-skycrawler.url', url: url
      end
    end

    def initialize(base_url, options = {})
      @connection = Faraday.new(base_url, options) do |faraday|
        if block_given?
          yield faraday
        end
      end
    end

    # TODO Support POST when we need
    def fetch(path, params = {})
      response = get(path)

      url = @connection.url_prefix + path

      yield url.to_s, response.headers, response.body

      urls = retrieve_links(response.body)

      enqueue_next_urls(urls)
    end

    def get(path, params = {})
      @connection.get(path, params)
    end

    def post(path, params = {})
      @connection.post(path, params)
    end

    private

    def retrieve_links(html)
      links = []
      html = Nokogiri::HTML(html)
      html.search("a").each do |element|
        links << element["href"]
      end
      links
    end

    def enqueue_next_urls(urls)
      # TODO Implement this
    end
  end
end
