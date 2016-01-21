require 'bundler/setup'

require 'daimon_skycrawlers/version'

module DaimonSkycrawlers
  class << self
    def register_processor(&block)
      HTTPResponseConsumer.register &block
    end
  end
end
