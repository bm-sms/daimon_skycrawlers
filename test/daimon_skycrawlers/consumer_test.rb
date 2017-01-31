require "helper"

class DaimonSkycrawlersConsumerTest < Test::Unit::TestCase
  class DummyProcessor < DaimonSkycrawlers::Processor::Base
    attr_reader :called

    def initialize
      super
      @called = false
    end

    def call(message)
      @called = true
    end
  end

  sub_test_case "HTTPResponse" do
    test "default processor" do
      message = { url: "http://example.com/", heartbeat: true }
      consumer = DaimonSkycrawlers::Consumer::HTTPResponse.new("test", ::Logger.new(nil))
      assert_nothing_raised do
        consumer.process(message)
      end
    end

    test "block processor" do
      message = { url: "http://example.com/" }
      called = false
      DaimonSkycrawlers::Consumer::HTTPResponse.register do |_message|
        called = true
      end
      consumer = DaimonSkycrawlers::Consumer::HTTPResponse.new("test", ::Logger.new(nil))
      assert_false(called)
      consumer.process(message)
      assert_true(called)
    end

    test "custom processor" do
      message = { url: "http://example.com/" }
      dummy_processor = DummyProcessor.new
      DaimonSkycrawlers::Consumer::HTTPResponse.register(dummy_processor)
      consumer = DaimonSkycrawlers::Consumer::HTTPResponse.new("test", ::Logger.new(nil))
      assert_false(dummy_processor.called)
      consumer.process(message)
      assert_true(dummy_processor.called)
    end
  end
end
