require "daimon_skycrawlers/processor/base"

module DaimonSkycrawlers
  module Processor
    class Proc < Base
      def initialize(handler)
        super()
        @handler = handler
      end

      def call(message)
        @handler.call(message)
      end
    end
  end
end
