require "bundler/setup"

require "daimon_skycrawlers/version"

module DaimonSkycrawlers
  class << self
    def register_processor(processor = nil, &block)
      DaimonSkycrawlers::Consumer::HTTPResponse.register(processor, &block)
    end

    def register_crawler(crawler)
      DaimonSkycrawlers::Consumer::URL.register(crawler)
    end
  end
end
