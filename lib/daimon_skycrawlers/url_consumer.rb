require 'daimon_skycrawlers/crawler'
require 'daimon_skycrawlers/processor'

module DaimonSkycrawlers
  class URLConsumer
    include SongkickQueue::Consumer

    consume_from_queue 'daimon-skycrawler.url'

    class << self
      def register(crawler)
        crawlers << crawler
      end

      private

      def crawlers
        @crawlers ||= []
      end
    end

    def process(message)
      url = message[:url]

      self.class.crawlers.each do |crawler|
        crawler.fetch(url)
      end
    end
  end
end
