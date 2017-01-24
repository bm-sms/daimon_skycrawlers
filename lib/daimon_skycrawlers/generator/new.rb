require "securerandom"
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
        config = {
          password: SecureRandom.urlsafe_base64
        }
        [
          "README.md",
          "config/database.yml",
          "docker-compose.yml",
          "env",
          "env.db",
        ].each do |path|
          if path.start_with?("env")
            template("#{path}.erb", "#{name}/.#{path}", config)
          else
            template("#{path}.erb", "#{name}/#{path}", config)
          end
        end
        migration_options = {
          destination_root: File.join(destination_root, name),
          timestamps: true
        }
        invoke(MigrationGenerator, [
                 "CreatePages",
                 "key:string",
                 "url:string",
                 "headers:text",
                 "body:binary",
                 "last_modified_at:datetime",
                 "etag:string"
               ],
               migration_options)
      end

      def insert_index
        Dir.glob(File.join(destination_root, name, "db/migrate/*_create_pages.rb")) do |entry|
          source = File.read(entry)
          replaced_source = source.gsub(/(^ +)t.timestamps$/) do |_match; indent|
            indent = $1
            <<-CODE.chomp
#{indent}t.timestamps

#{indent}t.index [:key]
#{indent}t.index [:key, :updated_at]
#{indent}t.index [:url]
#{indent}t.index [:url, :updated_at]
            CODE
          end
          File.write(entry, replaced_source)
        end
      end

      def copy_files
        [
          "Dockerfile",
          "Dockerfile.db",
          "Gemfile",
          "Rakefile",
          "app/crawler.rb",
          "app/processor.rb",
          "config/init.rb",
          "services/common/docker-entrypoint.sh",
          "services/db/init-user-db.sh"
        ].each do |path|
          copy_file(path, "#{name}/#{path}", mode: :preserve)
        end
      end

      def create_directories
        [
          "app/crawlers",
          "app/filters",
          "app/processors",
          "vendor/bundle",
          "docker-cache/bundle",
          "docker-cache/.bundle"
        ].each do |entry|
          empty_directory("#{name}/#{entry}")
        end
      end

      def display_post_message
        puts <<MESSAGE
Check .env and .env.db before running `docker-compose build` or `docker-compose up`.
MESSAGE
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
