require "daimon_skycrawlers"
require "daimon_skycrawlers/queue"
require "daimon_skycrawlers/timer"
require "daimon_skycrawlers/consumer/http_response"

module DaimonSkycrawlers
  module Processor
    class << self
      def run(process_name: "daimon-skycrawler:http-response")
        shutdown_interval = DaimonSkycrawlers.configuration.shutdown_interval
        DaimonSkycrawlers::Timer.setup_shutdown_timer("daimon-skycrawler.http-response", interval: shutdown_interval)
        SongkickQueue::Worker.new(process_name, [DaimonSkycrawlers::Consumer::HTTPResponse]).run
      end

      def enqueue_http_response(url, message = {})
        message[:url] = url
        SongkickQueue.publish("daimon-skycrawler.http-response", message)
      end
    end
  end
end
