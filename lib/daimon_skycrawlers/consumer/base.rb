require "songkick_queue"
require "daimon_skycrawlers/logger"

module DaimonSkycrawlers
  module Consumer
    class Base
      include DaimonSkycrawlers::LoggerMixin

      def process(message)
        raise NotImplementedError, "Must implement in subclass"
      end
    end
  end
end
