require 'bundler/setup'
require 'daimon_skycrawlers'

p '* Crawler', DaimonSkycrawlers::VERSION

DaimonSkycrawlers.target_url = 'http://example.com'

DaimonSkycrawlers.run :crawler
