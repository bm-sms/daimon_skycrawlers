require "songkick_queue"
require "daimon_skycrawlers"
require "daimon_skycrawlers/consumer/base"
require "daimon_skycrawlers/processor/default"

module DaimonSkycrawlers
  module Consumer
    class HTTPResponse < Base
      include SongkickQueue::Consumer

      class << self
        def register(processor = nil, &block)
          if block_given?
            processors << block
          else
            processors << processor
          end
        end

        def processors
          @processors ||= []
        end

        def default_processor
          DaimonSkycrawlers::Processor::Default.new
        end

        def queue_name
          "#{DaimonSkycrawlers.configuration.queue_name_prefix}.http-response"
        end
      end

      consume_from_queue queue_name

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
