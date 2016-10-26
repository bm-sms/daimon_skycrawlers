require "thor"
require "rails/generators"
require "rails/generators/actions"
require "rails/generators/active_record"
require "rails/generators/active_record/migration/migration_generator"

module DaimonSkycrawlers
  module Generator
    class New < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.join(__dir__, "templates", "new")
      end

      def create_files
        [
          "README.md",
          "config/database.yml",
        ].each do |path|
          template("#{path}.erb", "#{name}/#{path}")
        end
        migration_options = {
          destination_root: File.join(destination_root, name),
          timestamps: true
        }
        invoke(MigrationGenerator, [
                 "CreatePages",
                 "url:string",
                 "headers:text",
                 "body:binary",
                 "last_modified_at:datetime",
                 "etag:string"
               ],
               migration_options)
      end

      def copy_files
        [
          "Gemfile",
          "Rakefile",
          "app/crawlers/sample_crawler.rb",
          "app/processors/sample_processor.rb",
          "config/init.rb",
        ].each do |path|
          copy_file(path, "#{name}/#{path}", mode: :preserve)
        end
      end
    end

    class MigrationGenerator < ActiveRecord::Generators::MigrationGenerator
      def self.source_root
        ActiveRecord::Generators::MigrationGenerator.source_root
      end

      def create_migration_file
        set_local_assigns!
        validate_file_name!
        dest = options[:destination_root]
        migration_template(@migration_template, "#{dest}/db/migrate/#{file_name}.rb")
      end
    end
  end
end
