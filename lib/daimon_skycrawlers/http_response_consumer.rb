module DaimonSkycrawlers
  class HTTPResponseConsumer
    include SongkickQueue::Consumer

    consume_from_queue 'daimon-skycrawler.http-response'

    def process(message)
      # Implement sub class

      p '* ResponseHandler', message # XXX Remove this
    end
  end
end
