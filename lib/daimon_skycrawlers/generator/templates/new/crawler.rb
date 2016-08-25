#!/usr/bin/env ruby

require "daimon_skycrawlers/crawler"
require "daimon_skycrawlers/crawler/default"

require_relative "./init"

base_url = "http://example.com"

crawler = DaimonSkycrawlers::Crawler::Default.new(base_url)

DaimonSkycrawlers.register_crawler(crawler)

DaimonSkycrawlers::Crawler.run
