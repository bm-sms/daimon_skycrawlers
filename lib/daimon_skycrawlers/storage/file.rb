require "daimon_skycrawlers/storage/base"

module DaimonSkycrawlers
  module Storage
    #
    # Storage for files
    #
    class File < Base
      def initialize(base_dir)
        super()
        @base_dir = Pathname(base_dir)
      end

      def save(data)
        url = data[:url]
        message = data[:message]
        key = message[:key]
        response = data[:response]
        headers = response.headers
        body = response.body
        @base_dir.mkpath
        body_path(url, key).dirname.mkpath
        body_path(url, key).open("wb+") do |file|
          file.write(body)
        end
        headers_path(url, key).open("wb+") do |file|
          file.write(JSON.generate(headers))
        end
      end

      def read(url, message)
        key = message[:key]
        headers = JSON.parse(headers_path(url, key).read)
        body = body_path(url, key).read
        Page.new(url, key, headers, body, headers["last-modified"], headers["etag"])
      end

      Page = Struct.new(:url, :key, :headers, :body, :last_modified, :etag)

      private

      def body_path(url, key)
        url = URI(url)
        if key
          @base_dir + key
        else
          @base_dir + ".#{url.path}"
        end
      end

      def headers_path(url, key)
        url = URI(url)
        Pathname("#{body_path(url, key)}-headers.json")
      end
    end
  end
end
