require "helper"
require "daimon_skycrawlers/commands/runner"

class RunnerCommandText < Test::Unit::TestCase
  setup do
    @command = DaimonSkycrawlers::Commands::Runner.new
    @current_directory = Dir.pwd
    Dir.chdir(fixture_path("sample-project"))
  end

  teardown do
    Dir.chdir(@current_directory)
  end

  test "crawler" do
    mock(DaimonSkycrawlers::Crawler).run
    @command.invoke("crawler")
  end

  test "processor" do
    mock(DaimonSkycrawlers::Processor).run
    @command.invoke("processor")
  end
end
