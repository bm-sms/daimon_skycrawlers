require "thor"

module DaimonSkycrawlers
  module Generator
    class Crawler < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.join(__dir__, "templates")
      end

      def create_files
        config = {
          class_name: name.classify,
        }
        template("crawler.rb.erb", "app/crawlers/#{name.underscore}.rb", config)
      end
    end
  end
end
