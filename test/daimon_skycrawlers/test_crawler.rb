require "helper"

class DaimonSkycrawlersCrawlerTest < Test::Unit::TestCase
  sub_test_case "fetch html" do
    setup do
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("/") {|_env|
          [200, {}, "body"]
        }
        stub.post("/") {|_env|
          [200, {}, "body"]
        }
      end
      @crawler = ::DaimonSkycrawlers::Crawler::Default.new("http://example.com")
      @crawler.setup_connection do |faraday|
        faraday.adapter :test, stubs
      end
    end

    def test_fetch_get
      response = @crawler.fetch("http://example.com/", depth: 3)
      assert_equal({}, response.headers)
      assert_equal("body", response.body)
    end

    def test_fetch_post
      response = @crawler.fetch("http://example.com/", depth: 3, method: "POST")
      assert_equal({}, response.headers)
      assert_equal("body", response.body)
    end
  end

  sub_test_case "process" do
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
      message = {
        url: "http://example.com/blog",
        depth: 1
      }
      data = @crawler.process(message)
      assert_equal("http://example.com/blog", data[:url])
      assert_equal({ depth: 1 }, data[:message])
      assert_equal({}, data[:response].headers)
      assert_equal(@body, data[:response].body)
    end
  end

  sub_test_case "filter" do
    setup do
      @crawler = ::DaimonSkycrawlers::Crawler::Default.new("http://example.com", options: { obey_robots_txt: true })
      @crawler.storage = DaimonSkycrawlers::Storage::Null.new
      @url = "http://example.com/blog"
      @message = {
        url: @url,
        depth: 1
      }
    end

    test "robots_txt" do
      robots_txt_checker = mock(Object.new).allowed?(anything) { false }
      mock(DaimonSkycrawlers::Filter::RobotsTxtChecker).new(anything) { robots_txt_checker }
      mock(@crawler).schedule_to_process(@url, { heartbeat: true })
      @crawler.process(@message)
    end

    test "update_checker" do
      robots_txt_checker = mock(Object.new).allowed?(anything) { true }
      mock(DaimonSkycrawlers::Filter::RobotsTxtChecker).new(anything) { robots_txt_checker }
      update_checker = mock(Object.new).updated?(anything, anything) { false }
      mock(DaimonSkycrawlers::Filter::UpdateChecker).new(anything) { update_checker }
      mock(@crawler).schedule_to_process(@url, { heartbeat: true })
      @crawler.process(@message)
    end

    test "custom filter" do
      called = false
      @crawler.before_process do
        called = true
        false
      end
      mock(@crawler).schedule_to_process(@url, { heartbeat: true })
      @crawler.process(@message)
      assert_true(called)
    end
  end
end
