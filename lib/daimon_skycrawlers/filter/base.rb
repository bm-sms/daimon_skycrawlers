require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/config"

module DaimonSkycrawlers
  module Filter
    #
    # Base class of filters.
    #
    # You must implement `#call` in your filter and it must return
    # true or false. If your filter returns true, processors can
    # process given URL after your filter. Otherwise framework skips
    # given URL to skip processors.
    #
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
