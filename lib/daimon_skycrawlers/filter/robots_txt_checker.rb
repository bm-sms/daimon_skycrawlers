require "webrobots"
require "daimon_skycrawlers/filter/base"
require "daimon_skycrawlers/version"

module DaimonSkycrawlers
  module Filter
    #
    # This filter provides robots.txt checker for given URL.
    # We want to obey robots.txt provided by a web site.
    #
    class RobotsTxtChecker < Base
      def initialize(base_url: nil, user_agent: "DaimonSkycrawlers/#{DaimonSkycrawlers::VERSION}")
        super()
        @base_url = base_url
        @webrobots = WebRobots.new(user_agent)
      end

      #
      # @param message [Hash] check given URL is allowed or not by robots.txt
      # @return [true|false] Return true when web site allows to fetch the URL, otherwise return false
      #
      def call(message)
        url = normalize_url(message[:url])
        @webrobots.allowed?(url)
      end

      alias allowed? call
    end
  end
end
