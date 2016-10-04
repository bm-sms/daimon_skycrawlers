require "daimon_skycrawlers/crawler/base"
require "daimon_skycrawlers/filter/update_checker"
require "daimon_skycrawlers/filter/robots_txt_checker"

module DaimonSkycrawlers
  module Crawler
    #
    # The default crawler
    #
    # This crawler can GET given URL and store response to storage
    #
    class Default < Base
      def fetch(path, depth: 3, **kw)
        @n_processed_urls += 1
        @skipped = false
        url = connection.url_prefix + path
        robots_txt_checker = DaimonSkycrawlers::Filter::RobotsTxtChecker.new(base_url: @base_url)
        unless robots_txt_checker.call(url)
          skip(url)
          return
        end
        update_checker = DaimonSkycrawlers::Filter::UpdateChecker.new(storage: storage)
        unless update_checker.call(url.to_s, connection: connection)
          skip(url)
          return
        end
        @prepare.call(connection)
        response = get(path)
        data = [url.to_s, response.headers, response.body]

        yield(*data) if block_given?

        storage.save(*data)
        message = {
          depth: depth
        }
        message = message.merge(kw)
        schedule_to_process(url.to_s, message)
      end

      private

      def skip(url)
        log.info("Skip #{url}")
        @skipped = true
        schedule_to_process(url.to_s, heartbeat: true)
      end
    end
  end
end
