require 'bundler/setup'
require 'daimon_skycrawlers/crawler'

crawer = DaimonSkycrawlers::Crawler.new('http://example.com')

DaimonSkycrawlers.register_crawler(crawer)

DaimonSkycrawlers::Crawler.enqueu_url()
#crawer.fetch('/', depth: 1)

DaimonSkycrawlers::Crawler.run
