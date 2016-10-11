require "set"
require "daimon_skycrawlers/filter/base"

module DaimonSkycrawlers
  module Filter
    #
    # This filter provides duplication checker for given URL.
    #
    # Skip processing duplicated URLs.
    #
    class DuplicateChecker < Base
      def initialize(base_url: nil)
        @base_url = nil
        @base_url = URI(base_url) if base_url
        @urls = Set.new
      end

      #
      # @param [String] url to check duplication. If given URL is
      #        relative URL, use `@base_url + url` as absolute URL.
      # @return [true|false] Return false when duplicated, otherwise return true.
      #
      def call(url)
        unless URI(url).absolute?
          url = (@base_url + url).to_s
        end
        return false if @urls.include?(url)
        @urls << url
        true
      end

      #
      # @param [String] url to check duplication. If given URL is
      #        relative URL, use `@base_url + url` as absolute URL.
      # @return [true|false] Return true when duplicated, otherwise return false.
      #
      def duplicated?(url)
        !call(url)
      end
    end
  end
end
