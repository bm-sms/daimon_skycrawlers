require 'test_helper'

class DaimonSkycrawlersCrawlerTest < Test::Unit::TestCase
  sub_test_case 'fetch html' do
    setup do
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("/") {|env|
          [200, {}, "body"]
        }
      end
      @crawler = ::DaimonSkycrawlers::Crawler.new 'http://example.com' do |faraday|
        faraday.adapter :test, stubs
      end
    end

    def test_on_fetch
      @crawler.fetch "/" do |path, response|
        assert_equal("/", path)
        assert_equal({}, response.headers)
        assert_equal("body", response.body)
      end
    end
  end
end
