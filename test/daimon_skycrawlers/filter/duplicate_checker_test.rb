require "test_helper"
require "daimon_skycrawlers/filter/duplicate_checker"

class DaimonSkycrawlersDuplicateCheckerTest < Test::Unit::TestCase
  setup do
    @filter = DaimonSkycrawlers::Filter::DuplicateChecker.new(base_url: "http://example.com/blog/")
    @url = "http://example.com/blog/2016/1.html"
  end

  test "simple" do
    assert_true(@filter.call(url: @url))
    assert_false(@filter.call(url: @url))
  end

  test "relative" do
    assert_true(@filter.call(url: "./a.html"))
    assert_false(@filter.call(url: "./a.html"))
  end

  test "w/o host" do
    assert_true(@filter.call(url: "/index.html"))
    assert_false(@filter.call(url: "/index.html"))
  end
end
