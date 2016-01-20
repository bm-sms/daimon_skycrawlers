require 'net/http'
require 'uri'

module DaimonSkycrawlers
  class Crawler
    def on_fetch(&block)
      callbacks[:on_fetch] << block
    end

    def fetch(url)
      res = request(url)

      callbacks[:on_fetch].each do |callback|
        # TODO Use raw response header
        callback.call res.body
      end

      urls = retrieve_links(res.body)

      schedule_to_next_fetch urls
    end

    private

    def callbacks(&block)
      @callbacks ||= Hash.new {|hash, key| hash[key] = [] }
    end

    # TODO Support HTTP methods other than GET ?
    def request(url)
      uri = URI(url)

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

    def schedule_to_next_fetch(urls)
      # TODO Implement this
    end
  end
end
