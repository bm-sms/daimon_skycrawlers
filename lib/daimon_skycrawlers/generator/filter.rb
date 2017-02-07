require "thor"

module DaimonSkycrawlers
  # @private
  module Generator
    # @private
    class Filter < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.join(__dir__, "templates")
      end

      def create_files
        config = {
          class_name: name.classify,
        }
        template("filter.rb.erb", "app/filters/#{name.underscore}.rb", config)
      end

      def display_post_message
        puts <<MESSAGE

You can use this filter with both crawlers and processors.

    filter = #{name.classify}.new
    crawler = DaimonSkycrawlers::Crawler::Default.new
    crawler.before_process(filter)

MESSAGE
      end
    end
  end
end
