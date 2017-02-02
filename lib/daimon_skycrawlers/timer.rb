require "timers"
require "daimon_skycrawlers"

module DaimonSkycrawlers
  module Timer
    module_function

    # Setup timer for shutdown
    #
    # @param queue_name_prefix [String] previx of queue name
    # @param interval [String] shutdown after this interval after the queue is empty
    #
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
      timers
    end
  end
end
