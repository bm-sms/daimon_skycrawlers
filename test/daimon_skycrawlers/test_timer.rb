require "daimon_skycrawlers/timer"
require "helper"

class TimerTest < Test::Unit::TestCase
  test "simple timer" do
    called = false
    timers = DaimonSkycrawlers::Timer.setup_shutdown_timer("test", interval: 1) do
      called = true
    end
    sleep(2)
    timers.cancel
    assert(called)
  end

  test "reset timer" do
    called = false
    timers = DaimonSkycrawlers::Timer.setup_shutdown_timer("test", interval: 1) do
      called = true
    end
    sleep(0.5)
    ActiveSupport::Notifications.publish("consume_message.songkick_queue", Time.now, Time.now, 1, { queue_name: "test" })
    sleep(1)
    timers.cancel
    assert(!called)
  end
end
