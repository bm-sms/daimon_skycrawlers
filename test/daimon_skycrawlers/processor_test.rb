require "test_helper"

class DaimonSkycrawlersProcessorTest < Test::Unit::TestCase
  sub_test_case "before process" do
    setup do
      @processor = DaimonSkycrawlers::Processor::Default.new
    end

    test "skip invoking call method" do
      message = {
        url: "http://example.com"
      }
      mock(@processor).call(message).times(0)
      @processor.before_process do
        false
      end
      @processor.process(message)
    end

    test "invoke call method w/o before filter" do
      message = {
        url: "http://example.com"
      }
      mock(@processor).call(message).times(1)
      @processor.process(message)
    end
  end
end
