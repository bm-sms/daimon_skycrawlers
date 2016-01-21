require 'uri'

require 'faraday'
require 'nokogiri'

module DaimonSkycrawlers
  class Crawler
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

      yield path, response

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
