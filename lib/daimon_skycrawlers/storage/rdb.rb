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
      # @param [Hash] data has following keys
      #   * :url: URL
      #   * :message: Given message
      #   * :response: HTTP response
      #
      def save(data)
        url = data[:url]
        message = data[:message]
        key = message[:key] || url
        response = data[:response]
        headers = response.headers
        body = response.body
        Page.create(url: url,
                    key: key,
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
      def find(url, message)
        key = message[:key]
        if key
          Page.where(key: key).order(updated_at: :desc).limit(1).first
        else
          Page.where(url: url).order(updated_at: :desc).limit(1).first
        end
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
