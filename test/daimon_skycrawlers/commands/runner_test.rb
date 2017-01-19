require "test_helper"
require "daimon_skycrawlers/commands/runner"

class RunnerCommandText < Test::Unit::TestCase
  setup do
    @command = DaimonSkycrawlers::Commands::Runner.new
  end

  test "crawler" do
    mock(DaimonSkycrawlers::Crawler).run
    Dir.chdir(fixture_path("sample-project")) do
      @command.invoke("crawler")
    end
  end

  test "processor" do
    mock(DaimonSkycrawlers::Processor).run
    Dir.chdir(fixture_path("sample-project")) do
      @command.invoke("processor")
    end
  end
end
