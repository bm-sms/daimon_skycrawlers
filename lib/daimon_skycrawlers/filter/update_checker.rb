require "faraday"
require "daimon_skycrawlers/filter/base"

module DaimonSkycrawlers
  module Filter
    class UpdateChecker < Base
      def call(url, connection: nil)
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
