require "daimon_skycrawlers/logger"

module DaimonSkycrawlers
  module Processor
    class Base
      include DaimonSkycrawlers::LoggerMixin

      def call(message)
        raise "Implement this method in subclass"
      end

      def storage
        @storage ||= DaimonSkycrawlers::Storage::RDB.new
      end
    end
  end
end
