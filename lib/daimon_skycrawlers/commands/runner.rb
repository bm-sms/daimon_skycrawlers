require "thor"
require "daimon_skycrawlers"
require "daimon_skycrawlers/crawler"

module DaimonSkycrawlers
  # @private
  module Commands
    # @private
    class Runner < Thor
      namespace "exec"

      desc "crawler", "Execute crawler"
      def crawler
        load_init
        load_crawlers
        require(File.expand_path("app/crawler.rb", Dir.pwd))
        DaimonSkycrawlers::Crawler.run
      rescue => ex
        puts ex.message
        exit(false)
      end

      desc "processor", "Execute processor"
      def processor
        load_init
        load_processors
        require(File.expand_path("app/processor.rb", Dir.pwd))
        DaimonSkycrawlers::Processor.run
      rescue => ex
        puts ex.message
        exit(false)
      end

      private

      def load_init
        DaimonSkycrawlers.load_init
      end

      def load_crawlers
        DaimonSkycrawlers.load_crawlers
      end

      def load_processors
        DaimonSkycrawlers.load_processors
      end

      def log
        DaimonSkycrawlers.configuration.logger
      end
    end
  end
end
