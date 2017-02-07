require "daimon_skycrawlers"
require "daimon_skycrawlers/processor"
require "daimon_skycrawlers/processor/base"
require "daimon_skycrawlers/processor/spider"

class AmazonRanking < DaimonSkycrawlers::Processor::Base
  Item = Struct.new(:rank, :name, :url, :star, :review)
  def call(message)
    url = message[:url]
    page = storage.read(url)
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
