require "timers"
require "daimon_skycrawlers"

module DaimonSkycrawlers
  module Timer
    module_function

    def setup_shutdown_timer(queue_name_prefix, interval: 10)
      timers = Timers::Group.new
      timer = timers.after(interval) do
        if block_given?
          yield
        else
          Process.kill(:INT, 0)
        end
      end
      Thread.new(timers) do |t|
        loop { t.wait }
      end
      ActiveSupport::Notifications.subscribe("consume_message.songkick_queue") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        queue_name = event.payload[:queue_name]
        DaimonSkycrawlers.configuration.logger.debug("Reset timer: consume message #{queue_name}")
        timer.reset
      end
    end
  end
end
