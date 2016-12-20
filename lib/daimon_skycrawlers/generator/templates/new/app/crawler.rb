require "daimon_skycrawlers/crawler"
require "daimon_skycrawlers/crawler/default"

DaimonSkycrawlers.load_crawlers

base_url = "http://example.com"

crawler = DaimonSkycrawlers::Crawler::Default.new(base_url)

DaimonSkycrawlers.register_crawler(crawler)
