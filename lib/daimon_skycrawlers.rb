require "bundler/setup"

require "daimon_skycrawlers/version"
require "daimon_skycrawlers/logger"

module DaimonSkycrawlers
  Configuration = Struct.new(
    :logger,
    :queue_name_prefix,
    :crawler_interval,
    :shutdown_interval
  )
  class << self
    def register_processor(processor = nil, &block)
      DaimonSkycrawlers::Consumer::HTTPResponse.register(processor, &block)
    end

    def register_crawler(crawler)
      DaimonSkycrawlers::Consumer::URL.register(crawler)
    end

    def configuration
      @configuration ||= DaimonSkycrawlers::Configuration.new.tap do |config|
        config.logger = DaimonSkycrawlers::Logger.default
        config.queue_name_prefix = "daimon-skycrawlers"
        config.crawler_interval = 1
        config.shutdown_interval = 10
      end
    end

    def configure
      yield configuration
    end
  end
end
