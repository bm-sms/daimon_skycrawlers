require "daimon_skycrawlers"
require "daimon_skycrawlers/processor"
require "daimon_skycrawlers/processor/base"

require_relative "../models/itp_shop"

class ItpProcessor < DaimonSkycrawlers::Processor::Base
  def call(message)
    key_url = message[:url]
    page = storage.find(key_url)
    @doc = Nokogiri::HTML(page.body.encode("UTF-8", "CP932"))
    ItpShop.transaction do
      prepare_shops do |shop|
        itp_shop = ItpShop.find_or_initialize_by(itp_url: shop.itp_url)
        itp_shop.assign_attributes(shop.to_h)
        itp_shop.save!
      end
    end
    unless %r(/pg/) =~ key_url
      enqueue_pages(key_url)
    end
  end

  Shop = Struct.new(:name, :description, :itp_url, :zip_code, :address, :phone)

  private

  def prepare_shops
    @doc.search(".normalResultsBox").each do |shop|
      begin
      name = shop.at("section h4 .blueText").content.strip
      description = shop.at("section p").content.strip
      itp_path = shop.at("section h4 a").attr("href")
      phone = shop.at("section p b").content.strip
      address_element = shop.search("section p").detect do |element|
        /住所/ =~ element.content
      end
      address_element.search("span").unlink
      address_element.search("a").unlink
      address_text = address_element.content.strip
      zip_code = address_text.slice(/〒(\d{3}-\d{4})(.+)/, 1)
      address = address_text.slice(/〒(\d{3}-\d{4})(.+)/, 2).sub(/\A[[:space:]]+/, "")
      s = Shop.new(name,
                   description,
                   retrieve_individual_page_url(itp_path),
                   zip_code,
                   address,
                   phone)
      yield s
      rescue => e
        log.warn("#{e.class}: #{e.message}")
        log.debug(e.backtrace.join("\n"))
        break
      end
    end
  end

  # NOTE: HEAD request to itp.ne.jp is so slow
  #
  # /shop/KN2700060500184274/?url=%2F0663026300%2F&s_bid=KN2700060500184274&s_sid=FSP-LSR-002&s_fr=V01&s_ck=C01
  # http://nttbj.itp.ne.jp/0663026300/index.html
  def retrieve_individual_page_url(path)
    shop_id = path.slice(/\/\?url=(.+)&/, 1)
    uri = if shop_id
            URI("http://nttbj.itp.ne.jp/") + URI.unescape(shop_id) + "index.html"
          else
            URI("http://itp.ne.jp/") + path
          end
    uri.to_s
  end

  MAX_PAGE_NUM = 100

  def enqueue_pages(base_url)
    search_result = @doc.at("h1.searchResultHeader").content.strip.slice(/(\d+)件/, 1).to_i
    # itp.ne.jp can displays 5000 search results.
    2.upto([(search_result / 50), MAX_PAGE_NUM].min) do |n|
      url = URI.join(base_url, "pg/#{n}/?num=50")
      DaimonSkycrawlers::Crawler.enqueue_url(url.to_s)
    end
  end
end

processor = ItpProcessor.new
DaimonSkycrawlers.register_processor(processor)
