require "songkick_queue"

module DaimonSkycrawlers
  class Queue
    class << self
      def configure
        yield SongkickQueue.configuration
      end
    end
  end
end

# Default configuration
SongkickQueue.configure do |config|
  config.logger = Logger.new(STDOUT)
  config.host = "127.0.0.1"
  config.port = 5672
  # config.username = 'guest'
  # config.password = 'guest'
  config.vhost = "/"
  config.max_reconnect_attempts = 10
  config.network_recovery_interval = 1.0
end
