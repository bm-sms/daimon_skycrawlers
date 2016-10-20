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
    #
    # Register a processor
    #
    # @overload register_processor(processor)
    #   @param [Processor] processor instance which implements `call` method
    #   @return [void]
    #
    # @overload register_processor
    #   @return [void]
    #   @yield [message] Register given block as a processor.
    #   @yieldparam message [Hash] A message from queue
    #   @yieldreturn [void]
    #
    def register_processor(processor = nil, &block)
      DaimonSkycrawlers::Consumer::HTTPResponse.register(processor, &block)
    end

    #
    # Register a crawler
    #
    # @param [Crawler] crawler instance which implements `fetch` method
    # @return [void]
    #
    def register_crawler(crawler)
      DaimonSkycrawlers::Consumer::URL.register(crawler)
    end

    #
    # Retrieve configuration object
    #
    # @return [DaimonSkycrawlers::Configuration]
    #
    def configuration
      @configuration ||= DaimonSkycrawlers::Configuration.new.tap do |config|
        config.logger = DaimonSkycrawlers::Logger.default
        config.queue_name_prefix = "daimon-skycrawlers"
        config.crawler_interval = 1
        config.shutdown_interval = 10
      end
    end

    #
    # Configure DaimonSkycrawlers
    #
    # @return [void]
    # @yield [configuration] configure DaimonSkycrawlers
    # @yieldparam configuration [DaimonSkycrawlers::Configuration] configuration object
    # @yieldreturn [void]
    def configure
      yield configuration
    end

    #
    # Load "config/init.rb"
    #
    # @return [void]
    #
    def load_init
      require(File.expand_path("config/init.rb", Dir.pwd))
    rescue LoadError => ex
      puts ex.message
      exit(false)
    end

    #
    # Return current environment
    #
    def env
      ENV["SKYCRAWLERS_ENV"] || "development"
    end
  end
end
