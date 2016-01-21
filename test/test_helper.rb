$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'daimon_skycrawlers'
require 'daimon_skycrawlers/crawler'
require 'daimon_skycrawlers/processor'

require 'faraday'

require 'test/unit'
require 'pry'
require 'tapp'
