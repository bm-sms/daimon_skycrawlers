require 'pathname'
require 'yaml'

require 'bundler/setup'
require 'songkick_queue'

require 'daimon_skycrawlers/version'

module DaimonSkycrawlers
  autoload :Crawler, 'daimon_skycrawlers/crawler'
  autoload :URLConsumer, 'daimon_skycrawlers/url_consumer'
  autoload :HTTPResponseConsumer, 'daimon_skycrawlers/http_response_consumer'
  autoload :Dispatch, 'daimon_skycrawlers/dispatch'
  autoload :Scheduler, 'daimon_skycrawlers/scheduler'

  class << self
    def scheduler
      @scheduler ||= Scheduler.instance
    end
  end
end
