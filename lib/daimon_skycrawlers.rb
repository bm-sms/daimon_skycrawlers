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
    #   @param processor [Processor] instance which implements `call` method
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
    # @param crawler [Crawler] instance which implements `fetch` method
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
    # ```ruby
    # DaimonSkycrawlers.configure do |config|
    #   config.logger = DaimonSkycrawlers::Logger.default
    #   config.queue_name_prefix = "daimon-skycrawlers"
    #   config.crawler_interval = 1
    #   config.shutdown_interval = 10
    # end
    # ```
    #
    # * logger: logger instance
    # * queue_name_prefix: prefix of queue name.
    # * crawler_interval: crawling interval
    # * shutdown_interval: shutdown after interval after the queue is empty
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
    # Load "app/crawlers/**/*.rb"
    #
    # @return [void]
    #
    def load_crawlers
      Dir.glob("app/crawlers/**/*.rb") do |path|
        require(File.expand_path(path, Dir.pwd)) &&
          DaimonSkycrawlers.configuration.logger.info("Loaded crawler: #{path}")
      end
    end

    #
    # Load "app/processors/**/*.rb"
    #
    # @return [void]
    #
    def load_processors
      Dir.glob("app/processors/**/*.rb") do |path|
        require(File.expand_path(path, Dir.pwd)) &&
          DaimonSkycrawlers.configuration.logger.info("Loaded processor: #{path}")
      end
    end

    #
    # Return current environment
    #
    def env
      ENV["SKYCRAWLERS_ENV"] || "development"
    end
  end
end
