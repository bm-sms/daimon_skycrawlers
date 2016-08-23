#!/usr/bin/env ruby

require "daimon_skycrawlers/crawler"

base_url = "http://example.com"

crawler = DaimonSkycrawlers::Crawler.new(base_url)

DaimonSkycrawlers.register_crawler(crawler)

DaimonSkycrawlers::Crawler.run
