require "daimon_skycrawlers/logger"

module DaimonSkycrawlers
  module Storage
    include DaimonSkycrawlers::LoggerMixin

    class Base
      def save(url, headers, body)
        raise "Implement this in subclass"
      end

      def read(url)
        raise "Implement this in subclass"
      end
    end
  end
end
