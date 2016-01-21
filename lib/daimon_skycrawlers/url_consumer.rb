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

      def crawlers
        @crawlers ||= []
      end
    end

    def process(message)
      url = message[:url]

      # XXX When several crawlers are registed, how should they behave?
      self.class.crawlers.each do |crawler|
        crawler.fetch(url)
      end
    end
  end
end
