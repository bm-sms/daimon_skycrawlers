require "helper"
require "daimon_skycrawlers/processor/spider"
require "daimon_skycrawlers/storage/null"

class DaimonSkycrawlersSpiderTest < Test::Unit::TestCase
  setup do
    @spider = DaimonSkycrawlers::Processor::Spider.new
    @spider.storage = DaimonSkycrawlers::Storage::Null.new
  end

  test "empty message" do
    assert_nil(@spider.process({}))
  end
end
