require "helper"
require "daimon_skycrawlers/storage/rdb"

class DaimonSkycrawlers::Storage::RDBTest < Test::Unit::TestCase
  DummyResponse = Struct.new(:headers, :body)

  setup do
    @storage = DaimonSkycrawlers::Storage::RDB.new(fixture_path("database.yml").to_s)
    load(fixture_path("schema.rb"))
  end

  test "save/read w/ key" do
    time = Time.now
    headers = { "last-modified" => time.rfc2822, "etag" => "xxx" }
    data = {
      url: "http://example.com",
      message: {
        key: "example.com",
        params: { key: "value" }
      },
      response: DummyResponse.new(headers, "body")
    }
    assert_nothing_raised do
      @storage.save(data)
    end
    page = @storage.read("http://example.com", key: "example.com")
    expected_page = {
      url: "http://example.com",
      key: "example.com",
      headers: JSON.generate(headers),
      body: "body",
      last_modified_at: time.utc,
      etag: headers["etag"]
    }
    assert_equal(expected_page[:url], page.url)
    assert_equal(expected_page[:key], page.key)
    assert_equal(expected_page[:headers], page.headers)
    assert_equal(expected_page[:body], page.body)
    assert_equal(expected_page[:last_modified_at].to_s, page.last_modified_at.to_s)
    assert_equal(expected_page[:etag], page.etag)
  end

  test "save/read w/o key" do
    time = Time.now
    headers = { "last-modified" => time.rfc2822, "etag" => "xxx" }
    data = {
      url: "http://example.com",
      message: {
        params: { key: "value" }
      },
      response: DummyResponse.new(headers, "body")
    }
    assert_nothing_raised do
      @storage.save(data)
    end
    page = @storage.read("http://example.com")
    expected_page = {
      url: "http://example.com",
      key: "http://example.com",
      headers: JSON.generate(headers),
      body: "body",
      last_modified_at: time.utc,
      etag: headers["etag"]
    }
    assert_equal(expected_page[:url], page.url)
    assert_equal(expected_page[:key], page.key)
    assert_equal(expected_page[:headers], page.headers)
    assert_equal(expected_page[:body], page.body)
    assert_equal(expected_page[:last_modified_at].to_s, page.last_modified_at.to_s)
    assert_equal(expected_page[:etag], page.etag)
  end
end
