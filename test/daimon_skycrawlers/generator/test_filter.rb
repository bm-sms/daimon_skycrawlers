require "helper"
require "daimon_skycrawlers/generator/filter"

class GenerateFilterTest < Test::Unit::TestCase
  setup do
    @command = DaimonSkycrawlers::Generator::Filter
    @current_directory = Dir.pwd
    @working_directory = fixture_path("tmp/filter")
    @working_directory.mkpath
    Dir.chdir(@working_directory)
  end

  teardown do
    FileUtils.rm_rf(@working_directory)
    Dir.chdir(@current_directory)
  end

  test "generate filter" do
    out = capture_stdout do
      @command.start(["sample"])
    end
    expected = <<STRING
      create  app/filters/sample.rb

You can use this filter with both crawlers and processors.

    filter = Sample.new
    crawler = DaimonSkycrawlers::Crawler::Default.new
    crawler.before_process(filter)

STRING
    assert_equal(expected, out)
    source = File.read("app/filters/sample.rb")
    assert_equal("Sample", source[/^class (\w+) </, 1])
  end
end
