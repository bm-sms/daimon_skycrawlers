require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/config"
require "daimon_skycrawlers/callbacks"
require "daimon_skycrawlers/configurable"

module DaimonSkycrawlers
  module Processor
    class Base
      include DaimonSkycrawlers::LoggerMixin
      include DaimonSkycrawlers::ConfigMixin
      include DaimonSkycrawlers::Callbacks
      include DaimonSkycrawlers::Configurable

      def process(message)
        proceeding = run_before_callbacks(message)
        return unless proceeding
        call(message)
      end

      def call(message)
        raise "Implement this method in subclass"
      end

      def storage
        @storage ||= DaimonSkycrawlers::Storage::RDB.new
      end
    end
  end
end
