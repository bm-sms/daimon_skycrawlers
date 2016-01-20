require 'test_helper'

class DaimonSkycrawlersCrawlerTest < Test::Unit::TestCase
  sub_test_case 'fetch html' do
    setup do
      @crawler = ::DaimonSkycrawlers::Crawler.new
    end

    def test_on_fetch
      # TODO Mock it
      @crawler.fetch 'http://example.com' do |url, header, body|
        assert { url == 'http://example.com' }
        assert body
      end
    end
  end
end
