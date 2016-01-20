require 'digest/md5'

require 'perfectqueue'

module DaimonSkycrawlers
  # XXX It may just a data store?
  class Scheduler
    def initialize(config)
      @config = config
    end

    def init
      PerfectQueue.open(@config) do |queue|
        queue.client.init_database
      end
    end

    def run
      PerfectQueue::Worker.run(Dispatch) do
        @config
      end
    end

    # TODO Hide perfectqueue API from outside.

    def enqueue_url(url)
      open do |queue|
        queue.submit "url:#{Digest::MD5.hexdigest(url)}", 'url', url: url
      end
    end

    def enqueue_http_response(url, header, body)
      open do |queue|
        # TODO Use cache info for key
        queue.submit "response:#{Digest::MD5.hexdigest(url)}", 'http-response', url: url, header: header, body: body
      end
    end

    private

    def open(&block)
      PerfectQueue.open @config, &block
    end
  end
end
