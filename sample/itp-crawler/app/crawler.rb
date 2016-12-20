require "daimon_skycrawlers"
require "daimon_skycrawlers/crawler"
require "daimon_skycrawlers/crawler/default"

DaimonSkycrawlers.load_crawlers

base_url = "http://itp.ne.jp/"
crawler = DaimonSkycrawlers::Crawler::Default.new(base_url)
DaimonSkycrawlers.register_crawler(crawler)
