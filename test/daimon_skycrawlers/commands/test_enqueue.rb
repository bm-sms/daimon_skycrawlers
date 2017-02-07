require "helper"
require "daimon_skycrawlers/commands/enqueue"

class EnqueueCommandTest < Test::Unit::TestCase
  setup do
    @command = DaimonSkycrawlers::Commands::Enqueue.new
    @current_directory = Dir.pwd
    Dir.chdir(fixture_path("sample-project"))
  end

  teardown do
    Dir.chdir(@current_directory)
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

  sub_test_case "list" do
    test "default" do
      path = fixture_path("urls.txt")
      urls = [
        "http://example.com/1",
        "http://example.com/2",
        "http://example.com/3",
      ]
      urls.each do |url|
        mock(DaimonSkycrawlers::Crawler).enqueue_url(url)
      end
      @command.invoke("list", [path.to_s])
    end

    test "comment" do
      path = fixture_path("urls-with-comment.txt")
      urls = [
        "http://example.com/1",
        # "http://example.com/2",
        "http://example.com/3",
      ]
      urls.each do |url|
        mock(DaimonSkycrawlers::Crawler).enqueue_url(url)
      end
      @command.invoke("list", [path.to_s])
    end

    test "unknown type" do
      path = fixture_path("urls.txt")
      assert_raise(ArgumentError.new("Unknown type: unknown")) do
        @command.invoke("list", [path.to_s], type: "unknown")
      end
    end

    test "response" do
      path = fixture_path("urls.txt")
      urls = [
        "http://example.com/1",
        "http://example.com/2",
        "http://example.com/3",
      ]
      urls.each do |url|
        mock(DaimonSkycrawlers::Processor).enqueue_http_response(url)
      end
      @command.invoke("list", [path.to_s], type: "response")
    end
  end

  sub_test_case "yaml" do
    test "unknown type" do
      path = fixture_path("urls.yml")
      assert_raise(ArgumentError.new("Unknown type: unknown")) do
        @command.invoke("yaml", [path.to_s], type: "unknown")
      end
    end

    test "no url" do
      path = fixture_path("no-url.yml")
      assert_raise(RuntimeError.new("Could not find URL: {\"ulr\"=>\"http://example.com/1\"}")) do
        @command.invoke("yaml", [path.to_s], type: "response")
      end
    end

    test "urls" do
      path = fixture_path("urls.yml")
      urls = [
        "http://example.com/1",
        "http://example.com/2",
        "http://example.com/3",
      ]
      urls.each do |url|
        mock(DaimonSkycrawlers::Crawler).enqueue_url(url, {})
      end
      @command.invoke("yaml", [path.to_s])
    end

    test "urls with message" do
      path = fixture_path("urls-with-message.yml")
      urls = [
        "http://example.com/1",
        "http://example.com/2",
        "http://example.com/3",
      ]
      message = {
        "key1" => "value1",
        "key2" => "value2",
      }
      urls.each do |url|
        mock(DaimonSkycrawlers::Crawler).enqueue_url(url, message)
      end
      @command.invoke("yaml", [path.to_s])
    end

    test "response" do
      path = fixture_path("urls.yml")
      urls = [
        "http://example.com/1",
        "http://example.com/2",
        "http://example.com/3",
      ]
      urls.each do |url|
        mock(DaimonSkycrawlers::Processor).enqueue_http_response(url, {})
      end
      @command.invoke("yaml", [path.to_s], type: "response")
    end

    test "response with message" do
      path = fixture_path("urls-with-message.yml")
      urls = [
        "http://example.com/1",
        "http://example.com/2",
        "http://example.com/3",
      ]
      message = {
        "key1" => "value1",
        "key2" => "value2",
      }
      urls.each do |url|
        mock(DaimonSkycrawlers::Processor).enqueue_http_response(url, message)
      end
      @command.invoke("yaml", [path.to_s], type: "response")
    end

    test "urls in ERB" do
      path = fixture_path("urls-erb.yml")
      urls = [
        "http://example.com/1",
        "http://example.com/2",
        "http://example.com/3",
        "http://example.com/4",
        "http://example.com/5",
        "http://example.com/6",
        "http://example.com/7",
        "http://example.com/8",
        "http://example.com/9",
        "http://example.com/10"
      ]
      urls.each do |url|
        mock(DaimonSkycrawlers::Processor).enqueue_http_response(url, {})
      end
      @command.invoke("yaml", [path.to_s], type: "response")
    end
  end
end
