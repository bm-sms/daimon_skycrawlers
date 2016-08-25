#!/usr/bin/env ruby

require "daimon_skycrawlers/crawler"
require "daimon_skycrawlers/processor"

def usage
  $stderr.puts <<~USAGE
    #{$0}: Wrong usage
    Usage: #{$0} type URL

    Type:
      url: Fetch URL
      response: Process fetched data from URL

    Example:
      $ #{$0} url http://example.com/
      $ #{$0} response http://example.com/
  USAGE
  exit false
end

usage unless ARGV.size == 2

type = ARGV[0]
url = ARGV[1]

case type
when "url"
  DaimonSkycrawlers::Crawler.enqueue_url(url)
when "response"
  DaimonSkycrawlers::Processor.enqueue_http_response(url)
else
  usage
end
