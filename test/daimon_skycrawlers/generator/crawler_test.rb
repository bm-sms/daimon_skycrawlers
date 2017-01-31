require "helper"
require "daimon_skycrawlers/generator/crawler"

class GenerateCrawlerTest < Test::Unit::TestCase
  setup do
    @command = DaimonSkycrawlers::Generator::Crawler
    @current_directory = Dir.pwd
    @working_directory = fixture_path("tmp/crawler")
    @working_directory.mkpath
    Dir.chdir(@working_directory)
  end

  teardown do
    FileUtils.rm_rf(@working_directory)
    Dir.chdir(@current_directory)
  end

  test "generate crawler" do
    out = capture_stdout do
      @command.start(["sample"])
    end
    expected = <<STRING
      create  app/crawlers/sample.rb

You can register your crawler in `app/crawler.rb` to run your crawler.
Following code snippet is useful:

    base_url = "https://www.example.com/"
    crawler = Sample.new(base_url)
    DaimonSkycrawlers.register_crawler(crawler)

STRING
    assert_equal(expected, out)
    source = File.read("app/crawlers/sample.rb")
    assert_equal("Sample", source[/^class (\w+) </, 1])
  end
end
