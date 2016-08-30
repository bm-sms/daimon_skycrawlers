require "daimon_skycrawlers"
require "daimon_skycrawlers/queue"
require "daimon_skycrawlers/timer"
require "daimon_skycrawlers/consumer/url"

module DaimonSkycrawlers
  module Crawler
    class << self
      def run(process_name: "daimon-skycrawler:url")
        shutdown_interval = DaimonSkycrawlers.configuration.shutdown_interval
        DaimonSkycrawlers::Timer.setup_shutdown_timer("daimon-skycrawler.url", interval: shutdown_interval)
        SongkickQueue::Worker.new(process_name, [DaimonSkycrawlers::Consumer::URL]).run
      end

      def enqueue_url(url, message = {})
        message[:url] = url
        SongkickQueue.publish("daimon-skycrawler.url", message)
      end
    end
  end
end
