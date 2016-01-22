require "daimon_skycrawlers/storage/base"
require "active_record"

module DaimonSkycrawlers
  module Storage
    class RDB < Base
      def initialize
        ActiveRecord::Base.establish_connection(adapter: "sqlite3",
                                                database: "storage.db")
      end

      def save(url, headers, body)
        Page.create(url: url,
                    headers: JSON.generate(headers),
                    body: body,
                    last_modified_at: headers["Last-Modified"],
                    etag: headers["ETag"])
      end

      def find(url)
        Page.find(url: url)
      end

      class Page < ActiveRecord::Base
        self.table_name = "pages"
      end
    end
  end
end
