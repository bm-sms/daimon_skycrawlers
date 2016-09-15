require "songkick_queue"
require "daimon_skycrawlers"
require "daimon_skycrawlers/consumer/base"

module DaimonSkycrawlers
  module Consumer
    class URL < Base
      include SongkickQueue::Consumer

      class << self
        #
        # Register a given crawler
        #
        # @param [Crawler] crawler instance which implements `fetch` method
        # @return [void]
        #
        def register(crawler)
          crawlers << crawler
        end

        #
        # Returns registered crawlers
        #
        # @return [Array<Crawler>]
        #
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
          crawler.fetch(url, depth: depth)
          if crawler.skipped?
            sleep(crawler_interval) if crawler.n_processed_urls % 50 == 0
          else
            sleep(crawler_interval)
          end
        end
      end
    end
  end
end
