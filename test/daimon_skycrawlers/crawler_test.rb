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
      @crawler.fetch("http://example.com/", depth: 3) do |data|
        url = data[:url]
        message = data[:message]
        response = data[:response]
        assert_equal("http://example.com/", url)
        assert_equal({ depth: 3 }, message)
        assert_equal({}, response.headers)
        assert_equal("body", response.body)
      end
      assert_equal(1, @crawler.instance_variable_get(:@after_process_callbacks).size)
    end

    def test_fetch_post
      @crawler.fetch("http://example.com/", depth: 3, method: "POST") do |data|
        url = data[:url]
        message = data[:message]
        response = data[:response]
        assert_equal("http://example.com/", url)
        assert_equal({ depth: 3, method: "POST" }, message)
        assert_equal({}, response.headers)
        assert_equal("body", response.body)
      end
      assert_equal(1, @crawler.instance_variable_get(:@after_process_callbacks).size)
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
      @crawler.process(message) do |data|
        url = data[:url]
        m = data[:message]
        response = data[:response]
        assert_equal(url, "http://example.com/blog")
        assert_equal(m, message)
        assert_equal(response.headers, {})
        assert_equal(response.body, @body)
      end
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
