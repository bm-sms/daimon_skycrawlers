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

      def save(url, headers, body)
        @base_dir.mkpath
        body_path(url).dirname.mkpath
        body_path(url).open("wb+") do |file|
          file.write(body)
        end
        headers_path(url).open("wb+") do |file|
          file.write(JSON.generate(headers))
        end
      end

      def read(url)
        headers = JSON.parse(headers_path(url).read)
        body = body_path(url).read
        Page.new(url, headers, body, headers["last-modified"], headers["etag"])
      end

      Page = Struct.new(:url, :headers, :body, :last_modified, :etag)

      private

      def body_path(url)
        url = URI(url)
        @base_dir + ".#{url.path}"
      end

      def headers_path(url)
        url = URI(url)
        Pathname("#{body_path(url)}-headers.json")
      end
    end
  end
end
