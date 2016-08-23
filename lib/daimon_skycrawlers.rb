require "bundler/setup"

require "daimon_skycrawlers/version"

module DaimonSkycrawlers
  class << self
    def register_processor(processor = nil, &block)
      HTTPResponseConsumer.register(processor, &block)
    end

    def register_parser(parser = nil, &block)
      HTTPResponseConsumer.register(parser, &block)
    end

    def register_crawler(crawler)
      URLConsumer.register(crawler)
    end
  end
end
