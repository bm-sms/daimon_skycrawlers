$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'daimon_skycrawlers'
require 'daimon_skycrawlers/crawler'
require 'daimon_skycrawlers/processor'

require 'test/unit'
require 'test/unit/notify'
require 'test/unit/rr'
require 'pry'
require 'tapp'
require 'pathname'

ENV['SKYCRAWLERS_ENV'] ||= 'test'

def fixture_path(path)
  Pathname(__FILE__).dirname + "fixtures" + path
end
