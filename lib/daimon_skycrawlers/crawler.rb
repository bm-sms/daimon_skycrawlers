require 'net/http'
require 'uri'

module DaimonSkycrawlers
  class Crawler
    def fetch(url)
      res = request(url)

      # TODO Use raw response header
      yield url, nil, res.body

      urls = retrieve_links(res.body)

      enqueue_next_urls urls
    end

    private

    # TODO Support HTTP methods other than GET ?
    def request(url)
      uri = URI(url)

      # TODO Support HTTPS
      Net::HTTP.start(uri.host, uri.port) {|http|
        path = uri.path
        path = '/' + path unless path.start_with?('/')

        http.get(path)
      }
    end

    def retrieve_links(html)
      # TODO Implement this
      []
    end

    def enqueue_next_urls(urls)
      # TODO Implement this
    end
  end
end
