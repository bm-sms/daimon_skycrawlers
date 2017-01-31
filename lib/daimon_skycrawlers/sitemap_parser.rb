require "nokogiri"
require "typhoeus"
require "zlib"
require "uri"

module DaimonSkycrawlers
  # Based on https://github.com/benbalter/sitemap-parser
  class SitemapParser
    class Error < StandardError
    end

    def initialize(urls, options = {})
      @urls = urls
    end

    def parse
      hydra = Typhoeus::Hydra.new(max_concurrency: 1)
      sitemap_urls = []
      @urls.each do |url|
        if URI(url).scheme.start_with?("http")
          request = Typhoeus::Request.new(url, followlocation: true)
          request.on_complete do |response|
            sitemap_urls.concat(on_complete(response))
          end
          hydra.queue(request)
        else
          if File.exist?(url)
            extract_urls(File.read(url))
          end
        end
      end
      hydra.run
      sitemap_urls
    end

    private

    def on_complete(response)
      raise Error, "HTTP requset to #{response.effective_url} failed. status: #{response.code}" unless response.success?
      raw_sitemap = inflate_response(response)
      extract_urls(raw_sitemap)
    end

    def extract_urls(body)
      sitemap = Nokogiri::XML(body)
      case
      when sitemap.at("sitemapindex")
        urls = sitemap.search("sitemap").flat_map do |s|
          s.at("loc").content
        end
        SitemapParser.new(urls).parse
      when sitemap.at("urlset")
        sitemap.search("url").flat_map do |url|
          url.at("loc").content
        end
      else
        raise Error, "Malformed sitemap.xml no <sitemapindex> or <urlset>"
      end
    end

    def inflate_response(response)
      if compressed?(response)
        # We cannot inflate compressed data from NTFS filesystem (NT).
        # This can avoid errors
        stream = Zlib::Inflate.new(Zlib::MAX_WBITS + 32)
        stream.inflate(response.body)
      else
        response.body
      end
    end

    def compressed?(response)
      content_encoding = response.headers["Content-Encoding"]
      case content_encoding && content_encoding.downcase
      when "deflate", "gzip", "x-gzip"
        true
      else
        signature = response.body[0, 2]
        signature == "\x1F\x8B".b
      end
    end
  end
end
