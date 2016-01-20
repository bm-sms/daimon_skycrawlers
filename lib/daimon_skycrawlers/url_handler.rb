module DaimonSkycrawlers
  class URLHandler < ::PerfectQueue::Application::Base
    def run
      crawler = Crawler.new

      crawler.fetch task.data['url'] do |url, header, body|
        DaimonSkycrawlers.scheduler.enqueue_http_response url, header, body
      end
    end
  end
end
