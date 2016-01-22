module DaimonSkycrawlers
  module Storage
    class Null < Base
      def save(url, headers, body)
      end

      def find(url)
      end
    end
  end
end
