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
    end

    def process(message)
      self.class.processors.each do |processor|
        processor.call message
      end
    end
  end
end
