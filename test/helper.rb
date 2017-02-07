if ENV["COVERAGE"] == "yes"
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
    add_group "Consumer", ["consumer.rb", "/consumer/"]
    add_group "Crawler", ["crawler.rb", "/crawler/"]
    add_group "Filter", ["filter.rb", "/filter/"]
    add_group "Processor", ["processor.rb", "/processor/"]
    add_group "Storage", ["storage.rb", "/storage/"]
  end
end

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
require "stringio"

def fixture_path(path)
  Pathname(__FILE__).dirname + "fixtures" + path
end

def capture_stdout
  begin
    out = StringIO.new
    $stdout = out
    yield
    out.string
  ensure
    $stdout = STDOUT
  end
end

ENV["SKYCRAWLERS_ENV"] = "test"
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.configurations = YAML.load_file("test/fixtures/database.yml")
ActiveRecord::Base.establish_connection(DaimonSkycrawlers.env.to_sym)

DaimonSkycrawlers.configure do |config|
  config.queue_name_prefix = "daimon-skycrawlers.test"
  config.logger = ::Logger.new(nil)
end

# To run test
module Nokogiri
  module HTML
  end
end
