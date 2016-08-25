require "songkick_queue"

module DaimonSkycrawlers
  module Consumer
    class Base
      def process(message)
        raise NotImplementedError, "Must implement in subclass"
      end
    end
  end
end
