require "daimon_skycrawlers"
require "daimon_skycrawlers/processor"
require "daimon_skycrawlers/processor/base"
require "daimon_skycrawlers/processor/spider"

class AmazonRanking < DaimonSkycrawlers::Processor::Base
  Item = Struct.new(:rank, :name, :url, :star, :review)
  def call(message)
    url = message[:url]
    page = storage.find(url)
    doc = Nokogiri::HTML(page.body)
    ranking = []
    doc.search(".zg_itemRow").each do |item|
      rank = item.at(".zg_rankNumber").inner_text
      link = item.at(".zg_rankLine+a")
      star, review = item.search(".zg_rankLine+a+div a")
      ranking << Item.new(rank, link.inner_text, link[:href], star[:title], review.inner_text)
    end
    p ranking
  end
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
