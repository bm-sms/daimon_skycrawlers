require "delegate"
require "logger"

module DaimonSkycrawlers
  #
  # Logger for daimon_skycrawlers
  #
  class Logger < SimpleDelegator
    class << self
      #
      # Default logger
      #
      def default
        @default ||= DaimonSkycrawlers::Logger.new(STDOUT)
      end
    end

    # @private
    def initialize(logdev, shift_age = 0, shift_size = 1048576)
      @log = ::Logger.new(logdev, shift_age, shift_size)
      super(@log)
    end
  end

  module LoggerMixin
    # @private
    def initialize
      super
      @log = DaimonSkycrawlers::Logger.default
    end

    class << self
      def included(base)
        base.module_eval do
          attr_accessor :log
        end
      end
    end
  end
end
