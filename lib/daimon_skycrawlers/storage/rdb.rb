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
                    last_modified_at: headers["last-modified"],
                    etag: headers["etag"])
      end

      def find(url)
        Page.where(url: url).order(last_modified_at: :desc).limit(1).first
      end

      class Page < ActiveRecord::Base
        self.table_name = "pages"
      end
    end
  end
end
