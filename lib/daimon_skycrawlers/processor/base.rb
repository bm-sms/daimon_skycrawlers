module DaimonSkycrawlers
  module Processor
    class Base
      def call(message)
        raise "Implement this method in subclass"
      end

      def storage
        @storage ||= DaimonSkycrawlers::Storage::RDB.new
      end
    end
  end
end
