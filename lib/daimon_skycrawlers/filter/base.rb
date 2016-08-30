require "daimon_skycrawlers/logger"

module DaimonSkycrawlers
  module Filter
    class Base
      include DaimonSkycrawlers::LoggerMixin

      def storage
        @storage ||= DaimonSkycrawlers::Storage::RDB.new
      end

      def call(url)
        raise NotImplementedError, "Must implement this method in subclass"
      end
    end
  end
end
