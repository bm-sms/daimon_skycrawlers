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
        Base.configurations = YAML.load(ERB.new(::File.read(config_path)).result)
        Base.establish_connection(DaimonSkycrawlers.env.to_sym)
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

      class Base < ActiveRecord::Base
        self.abstract_class = true
      end

      class Page < Base
        self.table_name = "pages"
      end
    end
  end
end
