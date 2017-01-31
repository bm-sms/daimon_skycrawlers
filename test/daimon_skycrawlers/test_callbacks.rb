require "helper"
require "daimon_skycrawlers/callbacks"

class DaimonSkycrawlersCallbacksTest < Test::Unit::TestCase
  class Dummy
    include DaimonSkycrawlers::Callbacks

    attr_reader :processed

    def initialize
      super
      @processed = false
    end

    def process(message)
      proceeding = run_before_callbacks(message)
      return unless proceeding
      @processed = true
      data = {
        url: "http://example.com",
        message: message,
        response: ""
      }
      run_after_callbacks(data)
    end
  end

  class DummyFilter
    attr_reader :called, :stamp
    def call(message)
      @called = true
      @stamp = Time.now.to_f
      true
    end
  end

  class DummyAfterProcess
    attr_reader :called, :stamp
    def call(data)
      @called = true
      @stamp = Time.now.to_f
    end
  end

  sub_test_case "before" do
    test "sequence" do
      dummy = Dummy.new
      filter_log = []
      dummy.before_process do |_message|
        filter_log << 1
        true
      end
      dummy.before_process do |_message|
        filter_log << 2
        true
      end
      dummy.before_process do |_message|
        filter_log << 3
        true
      end
      dummy.process({})
      assert_equal([1, 2, 3], filter_log)
      assert_true(dummy.processed)
    end

    test "sequence class" do
      dummy = Dummy.new
      filter1 = DummyFilter.new
      filter2 = DummyFilter.new
      filter3 = DummyFilter.new
      dummy.before_process(filter1)
      dummy.before_process(filter2)
      dummy.before_process(filter3)
      dummy.process({})
      assert_true(filter1.called)
      assert_true(filter2.called)
      assert_true(filter3.called)
      stamps = [filter1.stamp, filter2.stamp, filter3.stamp]
      assert_equal(stamps, stamps.sort)
      assert_true(dummy.processed)
    end

    test "sequence mixed" do
      dummy = Dummy.new
      filter = DummyFilter.new
      stamp1 = nil
      stamp2 = nil
      dummy.before_process do |_message|
        stamp1 = Time.now.to_f
        true
      end
      dummy.before_process(filter)
      dummy.before_process do |_message|
        stamp2 = Time.now.to_f
        true
      end
      dummy.process({})
      stamps = [stamp1, filter.stamp, stamp2]
      assert_equal(stamps, stamps.sort)
      assert_true(dummy.processed)
    end

    test "not process if all filter returns false" do
      dummy = Dummy.new
      dummy.before_process do |_message|
        false
      end
      dummy.before_process do |_message|
        false
      end
      dummy.process({})
      assert_false(dummy.processed)
    end

    test "not process if 1 filter returns false" do
      dummy = Dummy.new
      dummy.before_process do |_message|
        true
      end
      dummy.before_process do |_message|
        false
      end
      dummy.process({})
      assert_false(dummy.processed)
    end

    test "clear before process callbacks" do
      dummy = Dummy.new
      filter_logs = []
      dummy.before_process do |_message|
        filter_logs << 1
      end
      dummy.before_process do |_message|
        filter_logs << 2
      end
      dummy.clear_before_process_callbacks
      dummy.process({})
      assert_true(filter_logs.empty?)
    end

    test "no filter" do
      dummy = Dummy.new
      dummy.process({})
      assert { dummy.processed }
    end
  end

  sub_test_case "after" do
    test "call" do
      dummy = Dummy.new
      dummy.after_process do |data|
        assert_equal({ url: "http://example.com", message: {}, response: "" }, data)
      end
      dummy.process({})
    end

    test "sequence" do
      dummy = Dummy.new
      after_process_logs = []
      dummy.after_process do |_data|
        after_process_logs << 1
      end
      dummy.after_process do |_data|
        after_process_logs << 2
      end
      dummy.after_process do |_data|
        after_process_logs << 3
      end
      dummy.process({})
      assert_equal([1, 2, 3], after_process_logs)
    end

    test "sequense class" do
      dummy = Dummy.new
      after_process1 = DummyAfterProcess.new
      after_process2 = DummyAfterProcess.new
      after_process3 = DummyAfterProcess.new
      dummy.after_process(after_process1)
      dummy.after_process(after_process2)
      dummy.after_process(after_process3)
      dummy.process({})
      stamps = [after_process1.stamp, after_process2.stamp, after_process3.stamp]
      assert_equal(stamps, stamps.sort)
    end
  end
end
