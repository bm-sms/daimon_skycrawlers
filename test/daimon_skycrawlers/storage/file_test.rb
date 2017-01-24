require "test_helper"
require "daimon_skycrawlers/storage/file"

class DaimonSkycrawlers::Storage::FileTest < Test::Unit::TestCase
  setup do
    @base_dir = fixture_path("storage").to_s
    @storage = DaimonSkycrawlers::Storage::File.new(@base_dir)
  end

  teardown do
    FileUtils.rm_rf(@base_dir)
  end

  test "save/read file" do
    url = "http://example.com/blog/index.html"
    response = Struct.new(:headers, :body).new({}, "body")
    data = {
      url: url,
      message: {},
      response: response
    }
    @storage.save(data)
    assert { File.exist?(@base_dir + "/blog/index.html") }
    assert { File.exist?(@base_dir + "/blog/index.html-headers.json") }
    page = @storage.read(url)
    expected = {
      url: url,
      headers: {},
      body: "body",
      etag: nil,
      last_modified: nil
    }
    assert_equal(expected, page.to_h)
  end
end
