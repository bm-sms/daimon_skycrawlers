require "test_helper"
require "daimon_skycrawlers/commands/enqueue"

class EnqueueCommandTest < Test::Unit::TestCase
  setup do
    @command = DaimonSkycrawlers::Commands::Enqueue.new
  end

  sub_test_case "url" do
    test "simple" do
      url = "http://example.com/"
      mock(DaimonSkycrawlers::Crawler).enqueue_url(url, {})
      @command.invoke("url", [url])
    end

    test "with message" do
      url = "http://example.com/"
      mock(DaimonSkycrawlers::Crawler).enqueue_url(url, "key" => "value")
      @command.invoke("url", [url, "key:value"])
    end
  end

  sub_test_case "response" do
    test "simple" do
      url = "http://example.com/"
      mock(DaimonSkycrawlers::Processor).enqueue_http_response(url, {})
      @command.invoke("response", [url])
    end

    test "with message" do
      url = "http://example.com/"
      mock(DaimonSkycrawlers::Processor).enqueue_http_response(url, "key" => "value")
      @command.invoke("response", [url, "key:value"])
    end
  end

  sub_test_case "sitemap" do
    test "sitemap.xml" do
      sitemap = "http://example.com/sitemap.xml"
      urls = [
        "http://example.com/1",
        "http://example.com/2",
        "http://example.com/3",
      ]
      sitemap_parser = mock(DaimonSkycrawlers::SitemapParser.new([sitemap]))
      sitemap_parser.parse { urls }
      mock(DaimonSkycrawlers::SitemapParser).new([sitemap]) { sitemap_parser }
      urls.each do |url|
        mock(DaimonSkycrawlers::Crawler).enqueue_url(url)
      end
      @command.invoke("sitemap", [sitemap])
    end

    test "robots.txt" do
      robots_txt = "http://example.com/robots.txt"
      sitemaps = [
        "http://example.com/sitemap1.xml",
        "http://example.com/sitemap2.xml"
      ]
      urls = [
        "http://example.com/1",
        "http://example.com/2",
        "http://example.com/3",
      ]
      webrobots = mock(WebRobots.new("test"))
      webrobots.sitemaps(robots_txt) { sitemaps }
      mock(WebRobots).new(anything) { webrobots }
      sitemap_parser = mock(DaimonSkycrawlers::SitemapParser.new(sitemaps))
      sitemap_parser.parse { urls }
      mock(DaimonSkycrawlers::SitemapParser).new(sitemaps) { sitemap_parser }
      urls.each do |url|
        mock(DaimonSkycrawlers::Crawler).enqueue_url(url)
      end
      @command.invoke("sitemap", [robots_txt], "robots-txt" => true)
    end
  end
end
