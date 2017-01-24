require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/config"

module DaimonSkycrawlers
  module Storage
    class Base
      include DaimonSkycrawlers::LoggerMixin
      include DaimonSkycrawlers::ConfigMixin

      def save(data)
        raise "Implement this in subclass"
      end

      def read(url)
        raise "Implement this in subclass"
      end
    end
  end
end
