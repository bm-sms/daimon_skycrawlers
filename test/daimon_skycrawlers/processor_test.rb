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

  sub_test_case "block processor" do
    setup do
      @called = false
      @processor = DaimonSkycrawlers::Processor::Proc.new(->(_message) { @called = true })
    end

    test "invoke handler" do
      message = {
        url: "http://example.com"
      }
      assert_false(@called)
      @processor.process(message)
      assert_true(@called)
    end
  end
end
