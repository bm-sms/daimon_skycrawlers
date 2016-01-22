require "daimon_skycrawlers/storage/rdb"

module DaimonSkycrawlers
  class Processor
    class Default
      def call(message)
        url = message[:url]
        storage = DaimonSkycrawlers::Storage::RDB.new
        page = storage.find(url)
        puts "URL: #{page.url}"
        puts "Body: #{page.body.bytesize} bytes"
        puts "Headers:"
        page.headers.each do |key, value|
          puts "  #{key}: #{value}"
        end
      end
    end
  end
end
