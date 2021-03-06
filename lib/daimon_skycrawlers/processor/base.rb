require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/config"
require "daimon_skycrawlers/callbacks"
require "daimon_skycrawlers/configurable"

module DaimonSkycrawlers
  module Processor
    #
    # The base class of processor
    #
    # A processor implementation can inherit this class and override
    # `#call` in the class.
    #
    class Base
      include DaimonSkycrawlers::LoggerMixin
      include DaimonSkycrawlers::ConfigMixin
      include DaimonSkycrawlers::Callbacks
      include DaimonSkycrawlers::Configurable

      # @!attribute [w] storage
      #   Set storage to crawler instance.
      #   @return [void]
      attr_writer :storage

      def initialize
        super
        @skipped = false

        setup_default_filters
      end

      # @private
      def skipped?
        @skipped
      end

      #
      # Process processor sequence
      #
      # 1. Run registered filters
      # 1. Process HTTP response from message
      #
      # @param message [Hash] parameters for processor
      #
      def process(message)
        @skipped = false
        proceeding = run_before_process_callbacks(message)
        unless proceeding
          skip(message[:url])
          return
        end
        call(message)
      end

      #
      # Process message
      #
      # Override this method in subclass
      #
      # @param message [Hash] parameters for processor
      #
      def call(message)
        raise "Implement this method in subclass"
      end

      #
      # Retrieve storage instance
      #
      def storage
        @storage ||= DaimonSkycrawlers::Storage::RDB.new
      end

      private

      def setup_default_filters
        before_process do |m|
          !m[:heartbeat]
        end
      end

      def skip(url)
        log.info("Skipped '#{url}' by '#{self.class}'")
        @skipped = true
      end
    end
  end
end
