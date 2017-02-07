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

      #
      # Retrieve storage instance
      #
      def storage
        @storage ||= DaimonSkycrawlers::Storage::RDB.new
      end

      #
      # Filter message
      #
      # Override this method in subclass.
      #
      # @param message [Hash] message can include anything
      #
      # @return [true|false] process the message if true otherwise skip message.
      #
      def call(message)
        raise NotImplementedError, "Must implement this method in subclass"
      end

      private

      def normalize_url(url)
        return url unless @base_url
        (URI(@base_url) + url).to_s
      end
    end
  end
end
