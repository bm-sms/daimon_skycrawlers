require "thor"

module DaimonSkycrawlers
  # @private
  module Generator
    # @private
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

      def display_post_message
        puts <<MESSAGE

You can register your crawler in `app/crawler.rb` to run your crawler.
Following code snippet is useful:

    base_url = "https://www.example.com/"
    crawler = #{name.classify}.new(base_url)
    DaimonSkycrawlers.register_crawler(crawler)

MESSAGE
      end
    end
  end
end
