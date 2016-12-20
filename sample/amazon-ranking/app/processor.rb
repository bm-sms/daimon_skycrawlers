require "daimon_skycrawlers"
require "daimon_skycrawlers/processor"

DaimonSkycrawlers.load_processors

DaimonSkycrawlers.register_processor do |data|
  p "It works with '#{data[:url]}'"
end

spider = DaimonSkycrawlers::Processor::Spider.new
spider.configure do |s|
  s.link_rules = "ul#zg_browseRoot li a"
  s.link_message = { next_processor: "AmazonRanking" }
  s.before_process do |message|
    message[:next_processor] != "AmazonRanking"
  end
end
DaimonSkycrawlers.register_processor(spider)

processor = AmazonRanking.new.configure do |s|
  s.before_process do |message|
    message[:next_processor] == "AmazonRanking"
  end
end
DaimonSkycrawlers.register_processor(processor)
