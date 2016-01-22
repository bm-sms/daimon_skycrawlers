require "daimon_skycrawlers/processor/default"

module DaimonSkycrawlers
  class HTTPResponseConsumer
    include SongkickQueue::Consumer

    consume_from_queue 'daimon-skycrawler.http-response'

    class << self
      def register(&block)
        processors << block
      end

      def processors
        @processors ||= []
      end

      def default_processor
        DaimonSkycrawlers::Processor::Default.new
      end
    end

    def process(message)
      if self.class.processors.empty?
        processors = self.class.processors
      else
        processors = [self.class.default_processor]
      end
      processors.each do |processor|
        processor.call(message)
      end
    end
  end
end
