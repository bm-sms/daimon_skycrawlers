require "daimon_skycrawlers"
require "daimon_skycrawlers/queue"
require "daimon_skycrawlers/timer"
require "daimon_skycrawlers/consumer/url"

module DaimonSkycrawlers
  module Crawler
    class << self
      def run(process_name: default_process_name)
        DaimonSkycrawlers::Timer.setup_shutdown_timer(queue_name, interval: config.shutdown_interval)
        SongkickQueue::Worker.new(process_name, [DaimonSkycrawlers::Consumer::URL]).run
      end

      def enqueue_url(url, message = {})
        message[:url] = url
        SongkickQueue.publish(queue_name, message)
      end

      def config
        DaimonSkycrawlers.configuration
      end

      def queue_name
        "#{config.queue_name_prefix}.url"
      end

      def default_process_name
        "#{config.queue_name_prefix}:url"
      end
    end
  end
end
