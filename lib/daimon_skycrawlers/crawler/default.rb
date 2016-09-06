require "daimon_skycrawlers/crawler/base"
require "daimon_skycrawlers/filter/update_checker"

module DaimonSkycrawlers
  module Crawler
    class Default < Base
      def fetch(path, depth: 3, **kw)
        @n_processed_urls += 1
        @skipped = false
        url = connection.url_prefix + path
        update_checker = DaimonSkycrawlers::Filter::UpdateChecker.new(storage)
        unless update_checker.call(url.to_s, connection: connection)
          log.info("Skip #{url}")
          @skipped = true
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
    end
  end
end
