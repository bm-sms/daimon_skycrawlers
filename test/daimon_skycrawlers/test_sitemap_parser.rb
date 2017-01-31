require "helper"
require "daimon_skycrawlers/sitemap_parser"

class SitemapParserTest < Test::Unit::TestCase
  setup do
    Typhoeus::Expectation.clear
  end

  data("given urls are not found" => 404,
       "server error" => 500)
  test "given urls are not found" do |(status)|
    url = "http://example.com/sitemap.xml"
    response = Typhoeus::Response.new(code: status, effective_url: url)
    Typhoeus.stub(url).and_return(response)
    sitemap_parser = DaimonSkycrawlers::SitemapParser.new([url])
    message = "HTTP requset to #{url} failed. status: #{status}"
    assert_raise(DaimonSkycrawlers::SitemapParser::Error.new(message)) do
      sitemap_parser.parse
    end
  end

  test "empty sitemap" do
    url = "http://example.com/sitemap.xml"
    response = Typhoeus::Response.new(code: 200, effective_url: url, headers: {}, body: "")
    Typhoeus.stub(url).and_return(response)
    sitemap_parser = DaimonSkycrawlers::SitemapParser.new([url])
    message = "Malformed sitemap.xml no <sitemapindex> or <urlset>"
    assert_raise(DaimonSkycrawlers::SitemapParser::Error.new(message)) do
      sitemap_parser.parse
    end
  end

  test "plain sitemap" do
    url = "http://example.com/sitemap.xml"
    response = Typhoeus::Response.new(code: 200,
                                      effective_url: url,
                                      headers: {},
                                      body: fixture_path("sitemap/sitemap.xml").read)
    Typhoeus.stub(url).and_return(response)
    sitemap_parser = DaimonSkycrawlers::SitemapParser.new([url])
    expected = [
      "https://example.com/1",
      "https://example.com/2",
    ]
    assert_equal(expected, sitemap_parser.parse)
  end

  test "multiple sitemaps" do
    urls = [
      "https://example.com/sitemap.xml",
      "https://example.com/sitemap1.xml",
      "https://example.com/sitemap2.xml",
    ]
    responses = urls.map do |url|
      Typhoeus::Response.new(code: 200,
                             effective_url: url,
                             headers: {},
                             body: fixture_path("sitemap/#{File.basename(url)}").read)
    end
    urls.zip(responses) do |url, response|
      Typhoeus.stub(url).and_return(response)
    end
    sitemap_parser = DaimonSkycrawlers::SitemapParser.new(urls)
    expected = [
      "https://example.com/1",
      "https://example.com/2",
      "https://example.com/11",
      "https://example.com/12",
      "https://example.com/21",
      "https://example.com/22",
    ]
    assert_equal(expected, sitemap_parser.parse)
  end

  test "sitemapindex" do
    index_url = "https://example.com/sitemap-index.xml"
    urls = [
      index_url,
      "https://example.com/sitemap1.xml",
      "https://example.com/sitemap2.xml",
    ]
    responses = urls.map do |url|
      Typhoeus::Response.new(code: 200,
                             effective_url: url,
                             headers: {},
                             body: fixture_path("sitemap/#{File.basename(url)}").read)
    end
    urls.zip(responses) do |url, response|
      Typhoeus.stub(url).and_return(response)
    end
    sitemap_parser = DaimonSkycrawlers::SitemapParser.new([index_url])
    expected = [
      "https://example.com/11",
      "https://example.com/12",
      "https://example.com/21",
      "https://example.com/22",
    ]
    assert_equal(expected, sitemap_parser.parse)
  end

  test "sitemapindex w/ compressed" do
    index_url = "https://example.com/sitemap-index-gz.xml"
    urls = [
      index_url,
      "https://example.com/sitemap1.xml.gz",
      "https://example.com/sitemap2.xml.gz",
    ]
    responses = urls.map do |url|
      headers = {}
      headers["Content-Encoding"] = "gzip" unless url == index_url
      Typhoeus::Response.new(code: 200,
                             effective_url: url,
                             headers: headers,
                             body: fixture_path("sitemap/#{File.basename(url)}").read)
    end
    urls.zip(responses) do |url, response|
      Typhoeus.stub(url).and_return(response)
    end
    sitemap_parser = DaimonSkycrawlers::SitemapParser.new([index_url])
    expected = [
      "https://example.com/11",
      "https://example.com/12",
      "https://example.com/21",
      "https://example.com/22",
    ]
    assert_equal(expected, sitemap_parser.parse)
  end

  test "local file" do
    sitemap_parser = DaimonSkycrawlers::SitemapParser.new([fixture_path("sitemap/sitemap.xml").to_s])
    expected = [
      "https://example.com/1",
      "https://example.com/2",
    ]
    assert_equal(expected, sitemap_parser.parse)
  end
end
