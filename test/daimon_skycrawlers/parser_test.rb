module DaimonSkycrawlers
  class DefaultParserTest < Test::Unit::TestCase
    def setup
      @parser = DaimonSkycrawlers::Parser::Default.new
      @parser.append_filter do |url|
        url.start_with?("http://www.clear-code.com/blog/")
      end
      @parser.append_filter do |url|
        %r!/2015/8/29.html\z! =~ url
      end
      @parser.parse(fixture_path("www.clear-code.com/blog.html").read)
    end

    def test_links
      assert_equal(["http://www.clear-code.com/blog/2015/8/29.html"], @parser.links)
    end
  end
end
