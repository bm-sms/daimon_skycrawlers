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

        def config
          DaimonSkycrawlers.configuration
        end
      end

      consume_from_queue "#{config.queue_name_prefix}.url"

      def process(message)
        url = message[:url]
        depth = message[:depth] || 0

        # XXX When several crawlers are registered, how should they behave?
        self.class.crawlers.each do |crawler|
          sleep(self.class.config.crawler_interval)
          crawler.fetch(url, depth: depth)
        end
      end
    end
  end
end
