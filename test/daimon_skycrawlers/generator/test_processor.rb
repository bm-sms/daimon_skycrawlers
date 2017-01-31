require "helper"
require "daimon_skycrawlers/generator/processor"

class GenerateProcessorTest < Test::Unit::TestCase
  setup do
    @command = DaimonSkycrawlers::Generator::Processor
    @current_directory = Dir.pwd
    @working_directory = fixture_path("tmp/processor")
    @working_directory.mkpath
    Dir.chdir(@working_directory)
  end

  teardown do
    FileUtils.rm_rf(@working_directory)
    Dir.chdir(@current_directory)
  end

  test "generate processor" do
    out = capture_stdout do
      @command.start(["sample"])
    end
    expected = <<STRING
      create  app/processors/sample.rb

You can register your processor in `app/processor.rb` to run your processor.
Following code snippet is useful:

    processor = Sample.new
    DaimonSkycrawlers.register_processor(processor)

STRING
    assert_equal(expected, out)
    source = File.read("app/processors/sample.rb")
    assert_equal("Sample", source[/^class (\w+) </, 1])
  end
end
