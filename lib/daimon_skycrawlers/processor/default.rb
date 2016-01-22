require "daimon_skycrawlers/storage/rdb"

module DaimonSkycrawlers
  class Processor
    class Default
      def call(message)
        url = message[:url]
        storage = DaimonSkycrawlers::Storage::RDB.new
        page = storage.find(url)
        headers = JSON.parse(page.headers)
        puts "URL: #{page.url}"
        puts "Body: #{page.body.bytesize} bytes"
        puts "Headers:"
        headers.each do |key, value|
          puts "  #{key}: #{value}"
        end
      end
    end
  end
end
