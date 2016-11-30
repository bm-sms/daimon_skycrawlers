require "test_helper"
require "daimon_skycrawlers/callbacks"

class DaimonSkycrawlersCallbacksTest < Test::Unit::TestCase
  class Dummy
    include DaimonSkycrawlers::Callbacks

    def process(message)
      run_before_callbacks(message)
    end
  end

  class DummyFilter
    attr_reader :called, :stamp
    def call(message)
      @called = true
      @stamp = Time.now.to_f
    end
  end

  test "sequence" do
    dummy = Dummy.new
    filter_log = []
    dummy.before_process do |_message|
      filter_log << 1
    end
    dummy.before_process do |_message|
      filter_log << 2
    end
    dummy.before_process do |_message|
      filter_log << 3
    end
    dummy.process({})
    assert_equal([1, 2, 3], filter_log)
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
  end

  test "sequence mixed" do
    dummy = Dummy.new
    filter = DummyFilter.new
    stamp1 = nil
    stamp2 = nil
    dummy.before_process do |_message|
      stamp1 = Time.now.to_f
    end
    dummy.before_process(filter)
    dummy.before_process do |_message|
      stamp2 = Time.now.to_f
    end
    stamps = [stamp1, filter.stamp, stamp2]
    assert_equal(stamps, stamps.sort)
  end
end
