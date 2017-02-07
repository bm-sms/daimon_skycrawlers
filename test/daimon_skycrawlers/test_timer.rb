require "daimon_skycrawlers/timer"
require "helper"

class TimerTest < Test::Unit::TestCase
  test "simple timer" do
    test_timers = Timers::Group.new
    called = false
    timers = DaimonSkycrawlers::Timer.setup_shutdown_timer("test", interval: 1) do
      called = true
    end
    timers.pause
    test_timers.after(2) do
      assert(called)
      timers.cancel
    end
    timers.resume
    test_timers.wait
  end

  test "reset timer" do
    test_timers = Timers::Group.new
    called = false
    timers = DaimonSkycrawlers::Timer.setup_shutdown_timer("test", interval: 1) do
      called = true
    end
    timers.pause
    test_timers.after(0.5) do
      ActiveSupport::Notifications.publish("consume_message.songkick_queue", Time.now, Time.now, 1, { queue_name: "test" })
    end
    test_timers.after(2) do
      timers.cancel
      assert(called)
    end
    timers.resume
    test_timers.wait
    test_timers.wait
  end
end
