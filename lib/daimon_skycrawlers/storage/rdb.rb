require "daimon_skycrawlers/storage/base"
require "active_record"

module DaimonSkycrawlers
  module Storage
    #
    # Storage for RDBMS
    #
    class RDB < Base
      def initialize(config_path = "config/database.yml")
        super()
        config = YAML.load_file(config_path)
        environment = ENV["SKYCRAWLERS_ENV"] || "development"
        ActiveRecord::Base.establish_connection(config[environment])
      end

      #
      # Save
      #
      # @param [String] url identity of the page
      # @param [Hash] header of URL
      # @param [String] body
      #
      def save(url, headers, body)
        Page.create(url: url,
                    headers: JSON.generate(headers),
                    body: body,
                    last_modified_at: headers["last-modified"],
                    etag: headers["etag"])
      end

      #
      # Fetch page identified by url
      #
      # @param [String] url identity of the page
      #
      def find(url)
        Page.where(url: url).order(last_modified_at: :desc).limit(1).first
      end

      class Page < ActiveRecord::Base
        self.table_name = "pages"
      end
    end
  end
end
