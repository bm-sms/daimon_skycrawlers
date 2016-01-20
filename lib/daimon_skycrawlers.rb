require 'pathname'
require 'yaml'

require "daimon_skycrawlers/version"

module DaimonSkycrawlers
  autoload :Crawler, 'daimon_skycrawlers/crawler'
  autoload :URLHandler, 'daimon_skycrawlers/url_handler'
  autoload :HTTPResponseHandler, 'daimon_skycrawlers/http_response_handler'
  autoload :Dispatch, 'daimon_skycrawlers/dispatch'
  autoload :Scheduler, 'daimon_skycrawlers/scheduler'

  class << self
    def scheduler
      # TODO Extract config
      @scheduler ||= Scheduler.new(YAML.load_file('test/fixtures/perfectqueue_config.yml'))
    end
  end
end
