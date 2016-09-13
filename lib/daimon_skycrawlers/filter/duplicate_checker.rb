require "set"
require "daimon_skycrawlers/filter/base"

module DaimonSkycrawlers
  module Filter
    class DuplicateChecker < Base
      def initialize(base_url: nil)
        @base_url = nil
        @base_url = URI(base_url) if base_url
        @urls = Set.new
      end

      def call(url)
        unless URI(url).absolute?
          url = (@base_url + url).to_s
        end
        return false if @urls.include?(url)
        @urls << url
        true
      end
    end
  end
end
