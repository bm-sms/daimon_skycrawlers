require "daimon_skycrawlers/crawler/base"

module DaimonSkycrawlers
  module Crawler
    class Default < Base
      def fetch(path, depth: 3, **kw)
        @prepare.call(connection)
        response = get(path)
        url = connection.url_prefix + path
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
