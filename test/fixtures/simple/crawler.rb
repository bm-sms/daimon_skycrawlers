require "bundler/setup"
require "daimon_skycrawlers/crawler"

base_url = "http://example.com"

crawler = DaimonSkycrawlers::Crawler.new(base_url)
crawler.parser.append_filter do |url|
  url.start_with?(base_url)
end

DaimonSkycrawlers.register_crawler(crawler)

DaimonSkycrawlers::Crawler.enqueue_url(base_url, depth: 2)

DaimonSkycrawlers::Crawler.run
