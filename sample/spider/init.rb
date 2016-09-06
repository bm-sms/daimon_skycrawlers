require "daimon_skycrawlers"
require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/queue"

DaimonSkycrawlers.configure do |config|
  config.logger = DaimonSkycrawlers::Logger.default
  config.logger.level = :debug
  config.crawler_interval = 1
  config.shutdown_interval = 30
end

DaimonSkycrawlers::Queue.configure do |config|
  # queue configuration
  config.logger = DaimonSkycrawlers.configuration.logger
  config.host = "127.0.0.1"
  config.port = 5672
  # config.username = 'guest'
  # config.password = 'guest'
  config.vhost = "/"
  config.max_reconnect_attempts = 10
  config.network_recovery_interval = 1.0
end
