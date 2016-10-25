require "daimon_skycrawlers"
require "daimon_skycrawlers/queue"
require "daimon_skycrawlers/timer"
require "daimon_skycrawlers/consumer/url"

module DaimonSkycrawlers
  module Crawler
    class << self
      #
      # Run registered crawlers
      #
      # @param process_name [String] Process name
      #
      def run(process_name: default_process_name)
        DaimonSkycrawlers::Timer.setup_shutdown_timer(config.queue_name_prefix, interval: config.shutdown_interval)
        SongkickQueue::Worker.new(process_name, [DaimonSkycrawlers::Consumer::URL]).run
      end

      #
      # Enqueue a URL to crawler queue
      #
      # @param [String] Specify absolute URL
      # @param [Hash] Extra parameters for crawler
      # @return [void]
      def enqueue_url(url, message = {})
        message[:url] = url
        config.logger.debug("#{queue_name}: #{url}")
        SongkickQueue.publish(queue_name, message)
      end

      #
      # Shortcut of DaimonSkycrawlers.configuration
      #
      # @return [DaimonSkycrawlers::Configuration]
      #
      def config
        DaimonSkycrawlers.configuration
      end

      #
      # Queue name for crawler
      #
      # @return [String] Queue name
      #
      def queue_name
        "#{config.queue_name_prefix}.url"
      end

      #
      # Default process name
      #
      # @return [String] Default process name
      #
      def default_process_name
        "#{config.queue_name_prefix}:url"
      end
    end
  end
end
