require "bundler/setup"
require "daimon_skycrawlers/crawler"
require "daimon_skycrawlers/crawler/default"

base_url = "http://example.com"

crawler = DaimonSkycrawlers::Crawler::Default.new(base_url)

DaimonSkycrawlers.register_crawler(crawler)

DaimonSkycrawlers::Crawler.enqueue_url(base_url, depth: 2)

DaimonSkycrawlers::Crawler.run
