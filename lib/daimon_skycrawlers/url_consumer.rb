require 'daimon_skycrawlers/crawler'
require 'daimon_skycrawlers/processor'

module DaimonSkycrawlers
  class URLConsumer
    include SongkickQueue::Consumer

    consume_from_queue 'daimon-skycrawler.url'

    def process(message)
      url = message[:url]
      crawler = Crawler.new(url)

      crawler.fetch(url) do |url, headers, body|
        DaimonSkycrawlers::Processor.enqueue_http_response(url, headers, body)
      end
    end
  end
end
