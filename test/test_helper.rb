$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "daimon_skycrawlers"
require "daimon_skycrawlers/crawler"
require "daimon_skycrawlers/crawler/default"
require "daimon_skycrawlers/processor"

require "test/unit"
require "test/unit/notify"
require "test/unit/rr"
require "pry"
require "tapp"
require "pathname"

def fixture_path(path)
  Pathname(__FILE__).dirname + "fixtures" + path
end

ENV["SKYCRAWLERS_ENV"] = "test"
ActiveRecord::Migration.verbose = false

DaimonSkycrawlers.configure do |config|
  config.queue_name_prefix = "daimon-skycrawlers.test"
  config.logger = ::Logger.new(nil)
end
