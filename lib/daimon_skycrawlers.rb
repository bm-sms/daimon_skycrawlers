require "bundler/setup"

require "daimon_skycrawlers/version"
require "daimon_skycrawlers/logger"

module DaimonSkycrawlers
  Configuration = Struct.new(
    :logger,
    :crawler_interval
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
        config.crawler_interval = 1
      end
    end

    def configure
      yield configuration
    end
  end
end
