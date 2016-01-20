module DaimonSkycrawlers
  class Dispatch < ::PerfectQueue::Application::Dispatch
    route 'url' => URLHandler
    # TODO Use sub class in dynamically
    route 'http-response' => HTTPResponseHandler
  end
end
