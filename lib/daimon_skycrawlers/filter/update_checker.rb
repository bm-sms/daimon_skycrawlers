require "faraday"
require "daimon_skycrawlers/filter/base"

module DaimonSkycrawlers
  module Filter
    #
    # This filter provides update checker for given URL.
    #
    # Skip processing URLs that is latest (not updated since previous
    # access).
    #
    class UpdateChecker < Base
      def initialize(storage: nil, base_url: nil)
        super(storage: storage)
        @base_url = nil
        @base_url = URI(base_url) if base_url
      end

      #
      # @param [Hash] message
      # @param connection [Faraday]
      # @return [true|false] Return true when need update, otherwise return false
      #
      def call(message, connection: nil)
        url = normalize_url(message[:url])
        page = storage.find(url)
        return true unless page
        if connection
          response = connection.head(url)
        else
          response = Faraday.head(url)
        end
        headers = response.headers
        case
        when headers.key?("etag") && page.etag
          headers["etag"] != page.etag
        when headers.key?("last-modified") && page.last_modified_at
          if headers["last-modified"] < page.last_modified_at
            log.warn("#{url} returns old contents. #{headers["last-modified"]} < #{page.last_modified_at}")
          end
          headers["last-modified"] > page.last_modified_at
        else
          true
        end
      end

      alias updated? call
    end
  end
end
