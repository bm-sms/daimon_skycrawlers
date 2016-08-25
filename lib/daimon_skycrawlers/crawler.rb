require "daimon_skycrawlers"
require "daimon_skycrawlers/queue"
require "daimon_skycrawlers/consumer/url"

module DaimonSkycrawlers
  class Crawler
    class << self
      def run(process_name: "daimon-skycrawler:url")
        SongkickQueue::Worker.new(process_name, [DaimonSkycrawlers::Consumer::URL]).run
      end

      def enqueue_url(url, depth: 3, interval: 1)
        SongkickQueue.publish("daimon-skycrawler.url", url: url, depth: depth, interval: interval)
      end
    end
  end
end
