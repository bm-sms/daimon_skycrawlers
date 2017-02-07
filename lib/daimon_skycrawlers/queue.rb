require "songkick_queue"

module DaimonSkycrawlers
  #
  # Wrapper for queue configuration class
  #
  class Queue
    class << self
      #
      # Configuration for queue
      #
      def configuration
        @configuration ||= SongkickQueue.configure do |config|
          config.logger = Logger.new(STDOUT)
          config.host = "127.0.0.1"
          config.port = 5672
          # config.username = 'guest'
          # config.password = 'guest'
          config.vhost = "/"
          config.max_reconnect_attempts = 10
          config.network_recovery_interval = 1.0
        end
      end

      #
      # Configure queue
      #
      # ```ruby
      # DaimonSkycrawlers::Queue.configure do |config|
      #   config.logger = Logger.new(STDOUT)
      #   config.host = "127.0.0.1"
      #   config.port = 5672
      #   # config.username = 'guest'
      #   # config.password = 'guest'
      #   config.vhost = "/"
      #   config.max_reconnect_attempts = 10
      #   config.network_recovery_interval = 1.0
      # end
      # ```
      #
      # * logger: logger instance for queue system
      # * host: RabbitMQ host
      # * port: RabbitMQ port
      # * username: RabbitMQ username
      # * passowrd: RabbitMQ password
      # * vhost: virtual host used for connection
      # * max_reconnect_attempts: The maximum number of reconnection attempts
      # * network_recovery_interval: reconnection interval for TCP connection failures
      #
      def configure
        yield configuration
      end
    end
  end
end
