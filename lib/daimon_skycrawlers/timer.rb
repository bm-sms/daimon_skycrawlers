require "timers"

module DaimonSkycrawlers
  module Timer
    module_function

    def setup_shutdown_timer(queue_name, interval: 10)
      timers = Timers::Group.new
      timer = timers.after(interval) do
        Process.kill(:INT, 0)
      end
      Thread.new(timers) do |t|
        loop { t.wait }
      end
      ActiveSupport::Notifications.subscribe("consume_message.songkick_queue") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:queue_name] == queue_name
          timer.reset
        end
      end
    end
  end
end
