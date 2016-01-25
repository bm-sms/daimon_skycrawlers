require 'thor'

module DaimonSkycrawlers
  module Generator
    class New < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.join(File.dirname(__FILE__), "templates", "new")
      end

      def create_files
        [
          "README.md",
          "config/database.yml",
        ].each do |path|
          template("#{path}.erb", "#{name}/#{path}")
        end
      end

      def copy_files
        [
          "Gemfile",
          "Rakefile",
          "crawler.rb",
          "enqueue.rb",
          "processor.rb",
        ].each do |path|
          copy_file(path, "#{name}/#{path}")
        end
      end
    end
  end
end
