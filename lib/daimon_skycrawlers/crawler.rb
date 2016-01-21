require 'faraday'
require 'uri'

module DaimonSkycrawlers
  class Crawler
    def initialize(url, options = {})
      @connection = Faraday.new(url, options) do |faraday|
        if block_given?
          yield faraday
        end
      end
    end

    # TODO Support POST when we need
    def fetch(url, params = {})
      response = get(url)

      yield url, response

      urls = retrieve_links(response.body)

      enqueue_next_urls urls
    end

    def get(url, params = {})
      @connection.get(url, params)
    end

    def post(url, params = {})
      @connection.post(url, params)
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
