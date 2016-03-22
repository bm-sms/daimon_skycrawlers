require 'test_helper'

class DaimonSkycrawlersCrawlerTest < Test::Unit::TestCase
  sub_test_case 'fetch html' do
    setup do
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.head("/") {|env|
          [200, {}]
        }
        stub.get("/") {|env|
          [200, {}, "body"]
        }
      end
      @crawler = ::DaimonSkycrawlers::Crawler.new('http://example.com')
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

  sub_test_case 'skip fetching' do
    setup do
      @last_modified_at = Time.now
      @etag = 'abc'
      @n_called_get = 0
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.head("/") {|env|
          [200, {'last-modified' => @last_modified_at, 'etag' => @etag}]
        }
        stub.get("/") {|env|
          @n_called_get += 1
          [200, {}, "body"]
        }
      end
      @crawler = ::DaimonSkycrawlers::Crawler.new('http://example.com')
      @crawler.setup_connection do |faraday|
        faraday.adapter :test, stubs
      end
      @crawler.storage = DaimonSkycrawlers::Storage::Null.new
    end

    def test_same_last_modified_at
      existing_record = {
        url: "http://example.com/",
        body: "body",
        last_modified_at: @last_modified_at,
        etag: nil,
      }
      @crawler.fetch("/")
      stub(@crawler.storage).find { existing_record }
      @crawler.fetch("/")
      assert_equal(1, @n_called_get)
    end

    def test_same_etag
      existing_record = {
        url: "http://example.com/",
        body: "body",
        last_modified_at: nil,
        etag: @etag,
      }
      @crawler.fetch("/")
      stub(@crawler.storage).find { existing_record }
      @crawler.fetch("/")
      assert_equal(1, @n_called_get)
    end
  end

  sub_test_case 'filter' do
    setup do
      @body = fixture_path("www.clear-code.com/blog.html").read
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.head("/") {|env|
          [200, {}]
        }
        stub.get("/blog") {|env|
          [200, {}, @body]
        }
      end
      @crawler = ::DaimonSkycrawlers::Crawler.new('http://example.com')
      @crawler.setup_connection do |faraday|
        faraday.adapter :test, stubs
      end
      @crawler.storage = DaimonSkycrawlers::Storage::Null.new
      mock(@crawler).schedule_to_process("http://example.com/blog")
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
