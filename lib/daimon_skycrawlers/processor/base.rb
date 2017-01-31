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

      def initialize
        super
        @skipped = false
      end

      def skipped?
        @skipped
      end

      def process(message)
        @skipped = false
        proceeding = run_before_callbacks(message)
        unless proceeding
          skip(message[:url])
          return
        end
        call(message)
      end

      def call(message)
        raise "Implement this method in subclass"
      end

      def storage
        @storage ||= DaimonSkycrawlers::Storage::RDB.new
      end

      private

      def skip(url)
        log.info("Skip #{url}")
        @skipped = true
      end
    end
  end
end
