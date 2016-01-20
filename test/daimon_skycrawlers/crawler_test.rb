require 'test_helper'

class DaimonSkycrawlersCrawlerTest < Test::Unit::TestCase
  sub_test_case 'fetch html' do
    setup do
      @crawler = ::DaimonSkycrawlers::Crawler.new
    end

    def test_on_fetch
      @crawler.on_fetch do |body|
        assert body
      end

      # TODO Mock it
      @crawler.fetch 'http://example.com'
    end
  end
end
