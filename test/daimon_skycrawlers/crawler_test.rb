require 'test_helper'

class DaimonSkycrawlersCrawlerTest < Test::Unit::TestCase
  sub_test_case 'fetch html' do
    setup do
      @crawler = ::DaimonSkycrawlers::Crawler.new 'http://example.com'
    end

    def test_on_fetch
      # TODO Mock it
      @crawler.fetch 'http://example.com' do |url, response|
        assert { url == 'http://example.com' }
        assert response
      end
    end
  end
end
