require "daimon_skycrawlers/crawler/default"

DaimonSkycrawlers.load_crawlers

base_url = "http://www.clear-code.com/blog/"

crawler = DaimonSkycrawlers::Crawler::Default.new(base_url)

DaimonSkycrawlers.register_crawler(crawler)
