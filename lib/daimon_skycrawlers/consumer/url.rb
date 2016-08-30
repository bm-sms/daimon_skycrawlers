require "songkick_queue"
require "daimon_skycrawlers/consumer/base"

module DaimonSkycrawlers
  module Consumer
    class URL < Base
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
        depth = message[:depth] || 0

        # XXX When several crawlers are registered, how should they behave?
        self.class.crawlers.each do |crawler|
          sleep(config.crawler_interval)
          crawler.fetch(url, depth: depth)
        end
      end
    end
  end
end
