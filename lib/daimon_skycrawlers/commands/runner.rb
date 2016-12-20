require "thor"
require "daimon_skycrawlers"
require "daimon_skycrawlers/crawler"

module DaimonSkycrawlers
  module Commands
    class Runner < Thor
      namespace "exec"

      desc "crawler", "Execute crawler"
      def crawler
        load_init
        Dir.glob("app/crawlers/**/*.rb") do |path|
          require(File.expand_path(path, Dir.pwd))
          log.info("Loaded crawler: #{path}")
        end

        Dir.glob("app/filters/**/*.rb") do |path|
          require(File.expand_path(path, Dir.pwd))
        end

        DaimonSkycrawlers::Crawler.run
      rescue => ex
        puts ex.message
        exit(false)
      end

      desc "processor", "Execute processor"
      def processor
        load_init
        Dir.glob("app/processors/**/*.rb") do |path|
          require(File.expand_path(path, Dir.pwd))
          log.info("Loaded processor: #{path}")
        end

        Dir.glob("app/filters/**/*.rb") do |path|
          require(File.expand_path(path, Dir.pwd))
        end

        DaimonSkycrawlers::Processor.run
      rescue => ex
        puts ex.message
        exit(false)
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
