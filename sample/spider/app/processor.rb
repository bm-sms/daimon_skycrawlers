require "daimon_skycrawlers/processor/spider"
require "daimon_skycrawlers/filter"
require "daimon_skycrawlers/filter/duplicate_checker"
require "daimon_skycrawlers/filter/update_checker"

default_processor = DaimonSkycrawlers::Processor::Default.new
spider = DaimonSkycrawlers::Processor::Spider.new
#spider.enqueue = false
spider.append_link_filter do |url|
  uri = URI(url)
  uri.host.nil? || uri.host == "www.clear-code.com"
end
spider.append_link_filter do |url|
  case url
  when %r!\A(\.\./|/|#)!
    false
  else
    true
  end
end
duplicate_checker = DaimonSkycrawlers::Filter::DuplicateChecker.new(base_url: "http://www.clear-code.com/blog/")
spider.append_link_filter(duplicate_checker)
update_checker = DaimonSkycrawlers::Filter::UpdateChecker.new(base_url: "http://www.clear-code.com/blog/")
spider.append_link_filter(update_checker)

DaimonSkycrawlers.register_processor(default_processor)
DaimonSkycrawlers.register_processor(spider)
