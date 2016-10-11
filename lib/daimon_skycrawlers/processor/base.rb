require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/config"

module DaimonSkycrawlers
  module Processor
    class Base
      include DaimonSkycrawlers::LoggerMixin
      include DaimonSkycrawlers::ConfigMixin

      def initialize
        super
        @before_process_filters = []
      end

      def before_process(filter = nil, &block)
        if block_given?
          @before_process_filters << block
        else
          @before_process_filters << filter if filter.respond_to?(:call)
        end
      end

      def process(message)
        return unless apply_before_filters(message[:url])
        call(message)
      end

      def call(message)
        raise "Implement this method in subclass"
      end

      def storage
        @storage ||= DaimonSkycrawlers::Storage::RDB.new
      end

      def apply_before_filters(url)
        @before_process_filters.all? do |filter|
          filter.call(url)
        end
      end
    end
  end
end
