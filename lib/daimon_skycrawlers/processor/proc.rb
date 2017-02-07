require "daimon_skycrawlers/processor/base"

module DaimonSkycrawlers
  module Processor
    #
    # Processor for Proc
    #
    class Proc < Base
      def initialize(handler)
        super()
        @handler = handler
      end

      #
      # Process message
      #
      def call(message)
        @handler.call(message)
      end
    end
  end
end
