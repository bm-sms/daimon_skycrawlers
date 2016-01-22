module DaimonSkycrawlers
  module Storage
    class Base
      def initialize(url, headers, body)
        @url = url
        @headers = headers
        @body = body
      end

      def save(url, headers, body)
        raise "Implement this in subclass"
      end
    end
  end
end
