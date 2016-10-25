require "test_helper"
require "daimon_skycrawlers/filter/update_checker"

class DaimonSkycrawlersUpdateCheckerTest < Test::Unit::TestCase
  setup do
    @filter = DaimonSkycrawlers::Filter::UpdateChecker.new(base_url: "http://example.com/blog/")
    @storage = DaimonSkycrawlers::Storage::RDB.new(fixture_path("database.yml"))
    load(fixture_path("schema.rb"))
    mock(@filter).storage { @storage }
    @url = "http://example.com/blog/2016/1.html"
  end

  test "url does not exist in storage" do
    mock(@storage).find(@url) { nil }
    assert_true(@filter.call(@url))
  end

  sub_test_case "url exist in storage" do
    test "need update when no etag and no last-modified" do
      page = DaimonSkycrawlers::Storage::RDB::Page.new(url: @url)
      connection = create_stub_connection(@url)
      mock(@storage).find(@url) { page }
      assert_true(@filter.call(@url, connection: connection))
    end

    test "need update when last-modified is newer than page.last_modified_at" do
      now = Time.now
      page = DaimonSkycrawlers::Storage::RDB::Page.new(url: @url, last_modified_at: Time.at(now - 1))
      connection = create_stub_connection(@url, "last-modified" => now)
      mock(@storage).find(@url) { page }
      assert_true(@filter.call(@url, connection: connection))
    end

    test "not need update when last-modified is older than page.last_modified_at" do
      now = Time.now
      page = DaimonSkycrawlers::Storage::RDB::Page.new(url: @url, last_modified_at: Time.at(now - 1))
      connection = create_stub_connection(@url, "last-modified" => Time.at(now - 2))
      mock(@storage).find(@url) { page }
      assert_false(@filter.call(@url, connection: connection))
    end

    test "etag matches" do
      page = DaimonSkycrawlers::Storage::RDB::Page.new(url: @url, etag: "xxxxx")
      connection = create_stub_connection(@url, "etag" => "xxxxx")
      mock(@storage).find(@url) { page }
      assert_false(@filter.call(@url, connection: connection))
    end

    test "need update when etag does not match" do
      now = Time.now
      page = DaimonSkycrawlers::Storage::RDB::Page.new(url: @url, etag: "xxxxx", last_modified_at: now)
      connection = create_stub_connection(@url, "etag" => "yyyyy", "last-modified" => Time.at(now + 1))
      mock(@storage).find(@url) { page }
      assert_true(@filter.call(@url, connection: connection))
    end

    test "need update with relative path w/o headers" do
      page = DaimonSkycrawlers::Storage::RDB::Page.new(url: @url)
      connection = create_stub_connection("/blog/2016/1.html")
      mock(@storage).find(@url) { page }
      assert_true(@filter.call("./2016/1.html", connection: connection))
    end

    private

    def create_stub_connection(url, headers = {})
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.head(url) {|env|
          [200, headers, "xxx"]
        }
      end
      Faraday.new("http://example.com/blog/") do |conn|
        conn.adapter :test, stubs
      end
    end
  end
end
