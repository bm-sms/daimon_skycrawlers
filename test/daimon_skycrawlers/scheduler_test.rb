require 'test_helper'

class DaimonSkycrawlersSchedulerTest < Test::Unit::TestCase
  setup do
    config = YAML.load_file('test/fixtures/perfectqueue_config.yml')

    DaimonSkycrawlers::Scheduler.new(config).init

    # XXX worker launched in main thread. This should be backgroud...
    DaimonSkycrawlers::Scheduler.new(config).run
  end

  def test_something
    # TODO Write some tests here...
  end
end
