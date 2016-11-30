require "songkick_queue"
require "daimon_skycrawlers"
require "daimon_skycrawlers/consumer/base"

module DaimonSkycrawlers
  module Consumer
    #
    # URL consumer class
    #
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

        #
        # @private
        #
        def queue_name
          "#{DaimonSkycrawlers.configuration.queue_name_prefix}.url"
        end
      end

      consume_from_queue queue_name

      #
      # @private
      #
      def process(message)
        crawler_interval = DaimonSkycrawlers.configuration.crawler_interval

        # XXX When several crawlers are registered, how should they behave?
        self.class.crawlers.each do |crawler|
          crawler.process(message.dup)
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
