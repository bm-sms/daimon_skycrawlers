require "daimon_skycrawlers/storage/rdb"
require "daimon_skycrawlers/processor/base"

module DaimonSkycrawlers
  module Processor
    class Default < Base
      def call(message)
        url = message[:url]
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
