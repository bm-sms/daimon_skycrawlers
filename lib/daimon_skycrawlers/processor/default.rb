require "daimon_skycrawlers/storage/rdb"
require "daimon_skycrawlers/processor/base"

module DaimonSkycrawlers
  module Processor
    #
    # Very simple processor
    #
    class Default < Base
      #
      # Display page information
      #
      def call(message)
        page = storage.read(message)
        headers = JSON.parse(page.headers)
        headers_string = headers.map {|key, value| "  #{key}: #{value}" }.join("\n")
        dumped_message = <<LOG
URL: #{page.url}
Body: #{page.body.bytesize} bytes
Headers:
#{headers_string}
LOG
        log.info(dumped_message)
      end
    end
  end
end
