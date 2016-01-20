module DaimonSkycrawlers
  class HTTPResponseHandler < ::PerfectQueue::Application::Base
    def run
      # Implement sub class

      p '* ResponseHandler', task # XXX Remove this
    end
  end
end
