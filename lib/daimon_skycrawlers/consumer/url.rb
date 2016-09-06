require "songkick_queue"
require "daimon_skycrawlers"
require "daimon_skycrawlers/consumer/base"

module DaimonSkycrawlers
  module Consumer
    class URL < Base
      include SongkickQueue::Consumer

      class << self
        def register(crawler)
          crawlers << crawler
        end

        def crawlers
          @crawlers ||= []
        end

        def queue_name
          "#{DaimonSkycrawlers.configuration.queue_name_prefix}.url"
        end
      end

      consume_from_queue queue_name

      def process(message)
        url = message[:url]
        depth = Integer(message[:depth] || 0)

        crawler_interval = DaimonSkycrawlers.configuration.crawler_interval

        # XXX When several crawlers are registered, how should they behave?
        self.class.crawlers.each do |crawler|
          sleep(crawler_interval)
          crawler.fetch(url, depth: depth)
        end
      end
    end
  end
end
