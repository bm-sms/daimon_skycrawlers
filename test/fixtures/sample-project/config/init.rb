require "bundler/setup"
require "daimon_skycrawlers"
require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/queue"

DaimonSkycrawlers.configure do |config|
  config.logger = ::Logger.new(nil)
  config.crawler_interval = 1
  config.shutdown_interval = 300
end

DaimonSkycrawlers::Queue.configure do |config|
  if ENV["CLOUDAMQP_URL"]
    amqp_uri = URI(ENV["CLOUDAMQP_URL"])
    config.host = amqp_uri.host
    config.username = amqp_uri.user
    config.password = amqp_uri.password
    config.vhost = amqp_uri.user
  else
    config.port = 5672
    config.host = ENV["SKYCRAWLERS_RABBITMQ_HOST"] || "localhost"
    config.vhost = "/"
  end
  config.logger = DaimonSkycrawlers.configuration.logger
  config.max_reconnect_attempts = 10
  config.network_recovery_interval = 1.0
end
