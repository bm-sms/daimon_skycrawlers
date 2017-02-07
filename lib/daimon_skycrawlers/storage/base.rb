require "daimon_skycrawlers/logger"
require "daimon_skycrawlers/config"

module DaimonSkycrawlers
  module Storage
    #
    # Base class of storage implementation
    #
    class Base
      include DaimonSkycrawlers::LoggerMixin
      include DaimonSkycrawlers::ConfigMixin

      #
      # Save data to storage
      #
      # Override this method in subclass
      #
      # @param data [Hash] data has following keys
      #   * `:url`: URL
      #   * `:message`: Given message
      #   * `:response`: HTTP response
      #
      def save(data)
        raise "Implement this in subclass"
      end

      #
      # Fetch page identified by url
      #
      # Override this method in subclass
      #
      # @param url [String] the key to find data in storage
      #
      def read(url, message = {})
        raise "Implement this in subclass"
      end
    end
  end
end
