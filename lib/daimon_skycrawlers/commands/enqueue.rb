require "daimon_skycrawlers"
require "daimon_skycrawlers/crawler"
require "daimon_skycrawlers/processor"
require "daimon_skycrawlers/sitemap_parser"
require "daimon_skycrawlers/version"
require "thor"
require "webrobots"

module DaimonSkycrawlers
  module Commands
    class Enqueue < Thor
      desc "url URL [key1:value1 key2:value2...]", "Enqueue URL for URL consumer"
      def url(url, *rest)
        load_init
        message = rest.map {|arg| arg.split(":") }.to_h
        log.debug("Enqueue URL for crawler: #{url} : #{message}")
        DaimonSkycrawlers::Crawler.enqueue_url(url, message)
      end

      desc "response URL [key1:value1 key2:value2...]", "Enqueue URL for HTTP response consumer"
      def response(url, *rest)
        load_init
        message = rest.map {|arg| arg.split(":") }.to_h
        log.debug("Enqueue URL for processor: #{url} : #{message}")
        DaimonSkycrawlers::Processor.enqueue_http_response(url, message)
      end

      desc "sitemap [OPTIONS] URL", "Enqueue URLs from simtemap.xml"
      method_option("robots-txt", aliases: ["-r"], type: :boolean,
                    desc: "URL for robots.txt. Detect robots.txt automatically if URL is not robots.txt")
      method_option("dump", type: :boolean, desc: "Dump URLs without enqueue")
      def sitemap(url)
        load_init
        if options["robots-txt"]
          webrobots = WebRobots.new("DaimonSkycrawlers/#{DaimonSkycrawlers::VERSION}")
          sitemaps = webrobots.sitemaps(url).uniq
        else
          sitemaps = [url]
        end
        sitemap_parser = DaimonSkycrawlers::SitemapParser.new(sitemaps)
        urls = sitemap_parser.parse
        if options["dump"]
          puts urls.join("\n")
          return
        end
        urls.each do |_url|
          DaimonSkycrawlers::Crawler.enqueue_url(_url)
        end
      end

      desc "list PATH", "Enqueue URLs from PATH. PATH content includes a URL per line"
      def list(path)
        load_init
        File.open(path, "r") do |file|
          file.each_line(chomp: true) do |line|
            line.chomp! # For Ruby 2.3.3 or earlier
            DaimonSkycrawlers::Crawler.enqueue_url(line)
          end
        end
      end

      private

      def load_init
        DaimonSkycrawlers.load_init
      end

      def log
        DaimonSkycrawlers.configuration.logger
      end
    end
  end
end
