require "daimon_skycrawlers/crawler/base"
require "daimon_skycrawlers/filter/update_checker"
require "daimon_skycrawlers/filter/robots_txt_checker"

module DaimonSkycrawlers
  module Crawler
    #
    # The default crawler
    #
    # This crawler can GET given URL and store response to storage
    #
    class Default < Base
      def fetch(url, message)
        response = get(url)
        data = [url.to_s, response.headers, response.body]

        yield(*data) if block_given?

        storage.save(*data)
        schedule_to_process(url.to_s, message)
      end
    end
  end
end
