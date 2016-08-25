require "daimon_skycrawlers/crawler"
require "daimon_skycrawlers/processor"

module DaimonSkycrawlers
  class URLConsumer
    include SongkickQueue::Consumer

    consume_from_queue "daimon-skycrawler.url"

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
      depth = message[:depth]
      interval = message[:interval]

      # XXX When several crawlers are registered, how should they behave?
      self.class.crawlers.each do |crawler|
        sleep(interval)
        crawler.fetch(url, depth: depth)
      end
    end
  end
end
