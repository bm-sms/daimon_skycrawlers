require "songkick_queue"
require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/config"

module DaimonSkycrawlers
  module Consumer
    #
    # Base class for consumer
    #
    # @private
    class Base
      include DaimonSkycrawlers::LoggerMixin
      include DaimonSkycrawlers::ConfigMixin

      # @private
      def process(message)
        raise NotImplementedError, "Must implement in subclass"
      end
    end
  end
end
