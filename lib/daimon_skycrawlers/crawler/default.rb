require "daimon_skycrawlers/crawler/base"

module DaimonSkycrawlers
  module Crawler
    #
    # The default crawler
    #
    # This crawler can GET given URL and store response to storage
    #
    class Default < Base
      def fetch(url, message)
        params = message[:params] || {}
        method = message[:method] || "GET"
        response = if method == "POST"
                     post(url, params)
                   else
                     get(url, params)
                   end
        data = { url: url, message: message, response: response }

        yield(data) if block_given?

        if @after_process_callbacks.empty?
          after_process do |_data|
            storage.save(data)
            schedule_to_process(url.to_s, message)
          end
        end
        response
      end
    end
  end
end
