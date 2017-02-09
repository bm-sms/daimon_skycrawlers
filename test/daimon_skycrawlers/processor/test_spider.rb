require "helper"
require "ostruct"
require "daimon_skycrawlers/processor/spider"
require "daimon_skycrawlers/storage/null"

class DaimonSkycrawlersSpiderTest < Test::Unit::TestCase
  setup do
    @spider = DaimonSkycrawlers::Processor::Spider.new
    @storage = DaimonSkycrawlers::Storage::Null.new
    @spider.storage = @storage
  end

  test "empty message" do
    assert_nil(@spider.process({}))
  end

  test "no link" do
    url = "http://example.com/"
    create_stub_connection(url) do |stub|
      stub.head(url) do |_env|
        [200, {}, ""]
      end
    end
    page = OpenStruct.new(headers: {}, body: "")
    mock(@storage).read(url: url).returns { page }
    @spider.process(url: url)
  end

  sub_test_case "blog" do
    setup do
      @spider.enqueue = false
      @url = "http://www.clear-code.com/blog.html"
      page = OpenStruct.new(headers: {}, body: fixture_path("www.clear-code.com/blog.html").read)
      mock(@storage).read(url: @url).returns { page }
    end

    test "enqueue all links" do
      mock(@spider).enqueue_url(anything, anything).times(256)
      @spider.process(url: @url)
    end

    test "filter same domain" do
      @spider.append_link_filter do |message|
        url = URI(message[:url])
        url.absolute? || url.hostname == "www.clear-code.com"
      end
      mock(@spider).enqueue_url(anything, anything).times(123)
      @spider.process(url: @url)
    end

    test "css selector" do
      @spider.link_rules = [".categories a"]
      [
        "category/cutter.html",
        "category/fluentd.html",
        "category/git.html",
        "category/groonga.html",
        "category/javascript.html",
        "category/milter-manager.html",
        "category/mozilla.html",
        "category/ruby.html",
        "category/uxu.html",
        "category/internship.html",
        "category/clear-code.html",
        "category/test.html",
        "category/company.html"
      ].each do |link|
        mock(@spider).enqueue_url(link, anything)
      end
      @spider.process(url: @url)
    end

    test "xpath" do
      @spider.link_rules = [%q{//div[@class="calendar"]/div[@class="year" and contains(text(), "2015")]/a}]
      [
        "./2015/1.html", "./2015/2.html", "./2015/3.html",
        "./2015/4.html", "./2015/5.html", "./2015/6.html",
        "./2015/7.html", "./2015/8.html", "./2015/9.html",
        "./2015/10.html", "./2015/11.html", "./2015/12.html"
      ].each do |link|
        mock(@spider).enqueue_url(link, anything)
      end
      @spider.process(url: @url)
    end

    test "multiple rules" do
      @spider.link_rules = [".categories a", ".calendar a"]
      mock(@spider).enqueue_url(anything, anything).times(106)
      @spider.process(url: @url)
    end
  end

  sub_test_case "search result" do
    setup do
      @spider.enqueue = false
      @url = "http://www.clear-code.com/search-result.html"
      page = OpenStruct.new(headers: {}, body: fixture_path("www.clear-code.com/search-result.html").read)
      mock(@storage).read(url: @url).returns { page }
    end

    test "search result and next page" do
      @spider.link_rules = [".search_result_entry_header .search_result_location a"]
      @spider.next_page_link_rules = [".next a"]
      [
        "http://www.clear-code.com/blog/2015/8/13.html",
        "http://www.clear-code.com/blog/2015/3/9.html",
        "http://www.clear-code.com/blog/2012/6/11.html",
        "http://www.clear-code.com/blog/2012/12/18.html",
        "http://www.clear-code.com/blog/2015/4/17.html",
        "http://www.clear-code.com/blog/2015/6/8.html",
        "http://www.clear-code.com/blog/2015/4/22.html",
        "http://www.clear-code.com/blog/2012/11/26.html",
        "http://www.clear-code.com/blog/2014/9/16.html",
        "http://www.clear-code.com/blog/2014/6/23.html",
        "/ranguba/search/query/fluentd?commit=%E6%A4%9C%E7%B4%A2&page=2&query=%E3%83%AA%E3%83%BC%E3%83%80%E3%83%96%E3%83%AB%E3%82%B3%E3%83%BC%E3%83%89&utf8=%E2%9C%93"
      ].each do |link|
        mock(@spider).enqueue_url(link, anything)
      end
      @spider.process(url: @url)
    end
  end

  sub_test_case "search result last page" do
    setup do
      @spider.enqueue = false
      @url = "http://www.clear-code.com/search-result.html"
      page = OpenStruct.new(headers: {}, body: fixture_path("www.clear-code.com/search-result-last-page.html").read)
      mock(@storage).read(url: @url).returns { page }
    end

    test "search result w/o next page" do
      @spider.link_rules = [".search_result_entry_header .search_result_location a"]
      @spider.next_page_link_rules = [".next a"]
      [
        "http://www.clear-code.com/blog/category/test.html",
      ].each do |link|
        mock(@spider).enqueue_url(link, anything)
      end
      @spider.process(url: @url)
    end
  end

  private

  def create_stub_connection(base_url)
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      yield stub
    end
    Faraday.new(base_url) do |conn|
      conn.adapter :test, stubs
    end
  end
end
