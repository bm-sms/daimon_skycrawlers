require "test_helper"

class DaimonSkycrawlersCrawlerTest < Test::Unit::TestCase
  sub_test_case "fetch html" do
    setup do
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("/") {|env|
          [200, {}, "body"]
        }
      end
      @crawler = ::DaimonSkycrawlers::Crawler::Default.new("http://example.com")
      @crawler.setup_connection do |faraday|
        faraday.adapter :test, stubs
      end
      @crawler.storage = DaimonSkycrawlers::Storage::Null.new
    end

    def test_on_fetch
      @crawler.fetch("/") do |url, headers, body|
        assert_equal("http://example.com/", url)
        assert_equal({}, headers)
        assert_equal("body", body)
      end
    end
  end

  sub_test_case "filter" do
    setup do
      @body = fixture_path("www.clear-code.com/blog.html").read
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("/blog") {|env|
          [200, {}, @body]
        }
      end
      @crawler = ::DaimonSkycrawlers::Crawler::Default.new("http://example.com")
      @crawler.setup_connection do |faraday|
        faraday.adapter :test, stubs
      end
      @crawler.storage = DaimonSkycrawlers::Storage::Null.new
      mock(@crawler).schedule_to_process("http://example.com/blog", { depth: 1 })
    end

    def test_fetch_blog
      @crawler.fetch("./blog", depth: 1) do |url, headers, body|
        assert_equal(url, "http://example.com/blog")
        assert_equal(headers, {})
        assert_equal(body, @body)
      end
    end
  end
end
