require "faraday"
require "daimon_skycrawlers/filter/base"

module DaimonSkycrawlers
  module Filter
    #
    # This filter provides update checker for given URL.
    #
    class UpdateChecker < Base
      def initialize(storage: nil, base_url: nil)
        super(storage: storage)
        @base_url = nil
        @base_url = URI(base_url) if base_url
      end

      #
      # @param [String] url
      # @param connection [Faraday]
      # @return [true|false] Return true when need update, otherwise return false
      #
      def call(url, connection: nil)
        unless URI(url).absolute?
          url = (@base_url + url).to_s
        end
        page = storage.find(url)
        return true unless page
        if connection
          headers = connection.head(url)
        else
          headers = Faraday.head(url)
        end
        return false if headers["etag"] && page.etag && headers["etag"] == page.etag
        return false if headers["last-modified"].nil? && page.last_modified_at.nil?
        return false if headers["last-modified"] <= page.last_modified_at
        true
      end
    end
  end
end
