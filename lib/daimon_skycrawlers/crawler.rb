require "daimon_skycrawlers"
require "daimon_skycrawlers/queue"
require "daimon_skycrawlers/timer"
require "daimon_skycrawlers/consumer/url"

module DaimonSkycrawlers
  module Crawler
    class << self
      def run(process_name: "daimon-skycrawlers:url")
        DaimonSkycrawlers::Timer.setup_shutdown_timer("#{config.queue_name_prefix}.url", interval: config.shutdown_interval)
        SongkickQueue::Worker.new(process_name, [DaimonSkycrawlers::Consumer::URL]).run
      end

      def enqueue_url(url, message = {})
        message[:url] = url
        SongkickQueue.publish("#{config.queue_name_prefix}.url", message)
      end

      def config
        DaimonSkycrawlers.configuration
      end
    end
  end
end
