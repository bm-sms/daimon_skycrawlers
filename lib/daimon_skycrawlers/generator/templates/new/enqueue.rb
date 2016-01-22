#!/usr/bin/env ruby

require "daimon_skycrawlers/crawler"

USAGE = "Usage: #{$0} [URL]"

if ARGV.size < 1
  $stderr.puts "#{$0}: missing URL"
  $stderr.puts USAGE
  exit false
end

url = ARGV[0]

DaimonSkycrawlers::Crawler.enqueue_url(url)
