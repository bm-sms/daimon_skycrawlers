module DaimonSkycrawlers
  class URLConsumer
    include SongkickQueue::Consumer

    consume_from_queue 'daimon-skycrawler.url'

    def process(message)
      crawler = Crawler.new

      crawler.fetch message[:url] do |url, header, body|
        DaimonSkycrawlers.scheduler.enqueue_http_response url, header, body
      end
    end
  end
end
