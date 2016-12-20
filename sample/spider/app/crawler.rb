require "daimon_skycrawlers/crawler/default"

base_url = "http://www.clear-code.com/blog/"

crawler = DaimonSkycrawlers::Crawler::Default.new(base_url)

DaimonSkycrawlers.register_crawler(crawler)
