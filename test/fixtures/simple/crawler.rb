require 'bundler/setup'
require 'daimon_skycrawlers/crawler'

p '* Crawler', DaimonSkycrawlers::VERSION

crawer = DaimonSkycrawlers::Crawler.new('http://example.com')

DaimonSkycrawlers.register_crawler(crawer)

crawer.fetch '/'

DaimonSkycrawlers::Crawler.run
