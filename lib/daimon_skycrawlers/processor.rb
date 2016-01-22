require 'daimon_skycrawlers'
require 'daimon_skycrawlers/configure_songkick_queue'
require 'daimon_skycrawlers/url_consumer'
require 'daimon_skycrawlers/http_response_consumer'

module DaimonSkycrawlers
  class Processor
    class << self
      def run(process_name: 'daimon-skycrawler:http-response')
        SongkickQueue::Worker.new(process_name, [HTTPResponseConsumer]).run
      end

      def enqueue_http_response(url)
        SongkickQueue.publish('daimon-skycrawler.http-response', url: url)
      end
    end
  end
end
