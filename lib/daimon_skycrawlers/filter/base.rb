require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/config"

module DaimonSkycrawlers
  module Filter
    class Base
      include DaimonSkycrawlers::LoggerMixin
      include DaimonSkycrawlers::ConfigMixin

      def initialize(storage: nil)
        super()
        @storage = storage
      end

      def storage
        @storage ||= DaimonSkycrawlers::Storage::RDB.new
      end

      def call(url)
        raise NotImplementedError, "Must implement this method in subclass"
      end
    end
  end
end
