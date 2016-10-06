require "thor"

module DaimonSkycrawlers
  module Generator
    class Processor < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.join(__dir__, "templates")
      end

      def create_files
        config = {
          class_name: name.classify,
        }
        template("processor.rb.erb", "app/processors/#{name.underscore}.rb", config)
      end
    end
  end
end
