require "daimon_skycrawlers/crawler/base"

module DaimonSkycrawlers
  module Crawler
    #
    # The default crawler
    #
    # This crawler can GET/POST given URL and store response to storage
    #
    class Default < Base
      #
      # GET/POST given url
      #
      # @param url [String] URI or path
      # @param message [Hash] message can include anything
      #
      # @return [Faraday::Response] HTTP response
      #
      def fetch(url, message)
        params = message[:params] || {}
        method = message[:method] || "GET"
        if method == "POST"
          post(url, params)
        else
          get(url, params)
        end
      end
    end
  end
end
