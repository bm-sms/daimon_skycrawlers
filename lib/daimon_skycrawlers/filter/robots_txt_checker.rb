require "webrobots"
require "daimon_skycrawlers/filter/base"
require "daimon_skycrawlers/version"

module DaimonSkycrawlers
  module Filter
    class RobotsTxtChecker < Base
      def initialize(base_url: nil, user_agent: "DaimonSkycrawlers/#{DaimonSkycrawlers::VERSION}")
        super
        @webrobots = WebRobots.new(user_agent)
      end

      def call(url)
        unless URI(url).absolute?
          url = (@base_url + url).to_s
        end
        @webrobots.allowed?(url)
      end
    end
  end
end
