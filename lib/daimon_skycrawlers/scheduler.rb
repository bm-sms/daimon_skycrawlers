require 'singleton'

module DaimonSkycrawlers
  # XXX It may just a data store?
  class Scheduler
    include Singleton

    def initialize
      # TODO Configure from outside
      SongkickQueue.configure do |config|
        config.logger = Logger.new(STDOUT)
        config.host = '127.0.0.1'
        config.port = 5672
        # config.username = 'guest'
        # config.password = 'guest'
        config.vhost = '/'
        config.max_reconnect_attempts = 10
        config.network_recovery_interval = 1.0
      end
    end

    # TODO Hide SongkickQueue API from outside.

    def enqueue_url(url)
      SongkickQueue.publish 'daimon-skycrawler.url', url: url
    end

    def enqueue_http_response(url, header, body)
      SongkickQueue.publish 'daimon-skycrawler.http-response', url: url, header: header, body: body
    end
  end
end
