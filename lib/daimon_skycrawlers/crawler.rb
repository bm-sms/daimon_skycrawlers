require "daimon_skycrawlers"
require "daimon_skycrawlers/queue"
require "daimon_skycrawlers/consumer/url"

module DaimonSkycrawlers
  module Crawler
    class << self
      def run(process_name: "daimon-skycrawler:url")
        SongkickQueue::Worker.new(process_name, [DaimonSkycrawlers::Consumer::URL]).run
      end

      def enqueue_url(url, message = {})
        message[:url] = url
        SongkickQueue.publish("daimon-skycrawler.url", message)
      end
    end
  end
end
