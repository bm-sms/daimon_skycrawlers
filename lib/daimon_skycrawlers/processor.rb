require "daimon_skycrawlers"
require "daimon_skycrawlers/queue"
require "daimon_skycrawlers/consumer/http_response"

module DaimonSkycrawlers
  class Processor
    class << self
      def run(process_name: "daimon-skycrawler:http-response")
        SongkickQueue::Worker.new(process_name, [HTTPResponseConsumer]).run
      end

      def enqueue_http_response(url)
        SongkickQueue.publish("daimon-skycrawler.http-response", url: url)
      end
    end
  end
end
