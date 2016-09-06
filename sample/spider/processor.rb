#!/usr/bin/env ruby

require "daimon_skycrawlers/processor"
require "daimon_skycrawlers/processor/spider"
require "daimon_skycrawlers/filter"
require "daimon_skycrawlers/filter/update_checker"

require_relative "./init"

default_processor = DaimonSkycrawlers::Processor::Default.new
spider = DaimonSkycrawlers::Processor::Spider.new
#spider.enqueue = false
spider.append_filter do |url|
  uri = URI(url)
  uri.host.nil? || uri.host == "www.clear-code.com"
end
spider.append_filter do |url|
  case url
  when %r!\A(\.\./|/|#)!
    false
  else
    true
  end
end
update_checker = DaimonSkycrawlers::Filter::UpdateChecker.new(base_url: "http://www.clear-code.com/blog/")
spider.append_filter(update_checker)

DaimonSkycrawlers.register_processor(default_processor)
DaimonSkycrawlers.register_processor(spider)

DaimonSkycrawlers::Processor.run
