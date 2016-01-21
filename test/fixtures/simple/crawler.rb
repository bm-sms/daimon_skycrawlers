require 'bundler/setup'
require 'daimon_skycrawlers'

p '* Crawler', DaimonSkycrawlers::VERSION

DaimonSkycrawlers.target_url = 'http://example.com'

# XXX konna kanji?
# DaimonSkycrawlers.run :crawler
