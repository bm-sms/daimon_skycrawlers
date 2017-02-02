require "daimon_skycrawlers"
require "daimon_skycrawlers/queue"
require "daimon_skycrawlers/timer"
require "daimon_skycrawlers/consumer/http_response"

module DaimonSkycrawlers
  module Processor
    class << self
      #
      # Run registered processors
      #
      # @param process_name [String] Process name
      #
      def run(process_name: default_process_name)
        if config.shutdown_interval > 0
          DaimonSkycrawlers::Timer.setup_shutdown_timer(config.queue_name_prefix, interval: config.shutdown_interval)
        end
        SongkickQueue::Worker.new(process_name, [DaimonSkycrawlers::Consumer::HTTPResponse]).run
      end

      #
      # Enqueue a URL to processor queue
      #
      # @param url [String] Specify absolute URL
      # @param message [Hash] Extra parameters for crawler
      # @return [void]
      def enqueue_http_response(url, message = {})
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
      # Queue name for processor
      #
      # @return [String] Queue name
      #
      def queue_name
        "#{config.queue_name_prefix}.http-response"
      end

      #
      # Default process name
      #
      # @return [String] Default process name
      #
      def default_process_name
        "#{config.queue_name_prefix}:http-response"
      end
    end
  end
end
