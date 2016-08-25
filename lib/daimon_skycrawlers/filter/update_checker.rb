require "faraday"
require "daimon_skycrawlers/filter/base"

module DaimonSkycrawlers
  module Filter
    class UpdateChecker < Base
      def call(url)
        page = storage.find(url)
        return false unless page
        headers = Faraday.head(url)
        return false if headers["etag"] && page.etag && headers["etag"] == page.etag
        return false if headers["last-modified"].nil? && page.last_modified_at.nil?
        return false if headers["last-modified"] <= page.last_modified_at
        true
      end
    end
  end
end
