require "daimon_skycrawlers"
require "daimon_skycrawlers/queue"
require "daimon_skycrawlers/timer"
require "daimon_skycrawlers/consumer/http_response"

module DaimonSkycrawlers
  module Processor
    class << self
      def run(process_name: "daimon-skycrawler:http-response")
        DaimonSkycrawlers::Timer.setup_shutdown_timer("#{config.queue_name_prefix}.http-response", interval: config.shutdown_interval)
        SongkickQueue::Worker.new(process_name, [DaimonSkycrawlers::Consumer::HTTPResponse]).run
      end

      def enqueue_http_response(url, message = {})
        message[:url] = url
        SongkickQueue.publish("#{config.queue_name_prefix}.http-response", message)
      end

      def config
        DaimonSkycrawlers.configuration
      end
    end
  end
end
