require "songkick_queue"
require "daimon_skycrawlers"
require "daimon_skycrawlers/consumer/base"
require "daimon_skycrawlers/processor/default"

module DaimonSkycrawlers
  module Consumer
    #
    # HTTP response consumer class
    #
    class HTTPResponse < Base
      include SongkickQueue::Consumer

      class << self
        #
        # Register a processor
        #
        # @overload register(processor)
        #   @param [Processor] processor instance which implements `call` method
        #   @return [void]
        #
        # @overload register
        #   @return [void]
        #   @yield [message] register given block as a processor
        #   @yieldparam message [Hash] A message from queue
        #   @yieldreturn [void]
        #
        def register(processor = nil, &block)
          if block_given?
            processors << block
          else
            processors << processor
          end
        end

        #
        # @private
        #
        def processors
          @processors ||= []
        end

        #
        # @private
        #
        def default_processor
          DaimonSkycrawlers::Processor::Default.new
        end

        #
        # @private
        #
        def queue_name
          "#{DaimonSkycrawlers.configuration.queue_name_prefix}.http-response"
        end
      end

      consume_from_queue queue_name

      #
      # @private
      #
      def process(message)
        if self.class.processors.empty?
          processors = [self.class.default_processor]
        else
          processors = self.class.processors
        end
        processors.each do |processor|
          processor.call(message)
        end
      end
    end
  end
end
