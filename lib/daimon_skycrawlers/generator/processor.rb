require "thor"
require "pathname"

module DaimonSkycrawlers
  # @private
  module Generator
    # @private
    class Processor < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        (Pathname(__dir__) + "../../../templates").to_s
      end

      def create_files
        config = {
          class_name: name.classify,
        }
        template("processor.rb.erb", "app/processors/#{name.underscore}.rb", config)
      end

      def display_post_message
        puts <<MESSAGE

You can register your processor in `app/processor.rb` to run your processor.
Following code snippet is useful:

    processor = #{name.classify}.new
    DaimonSkycrawlers.register_processor(processor)

MESSAGE
      end
    end
  end
end
