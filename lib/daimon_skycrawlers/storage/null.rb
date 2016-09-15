module DaimonSkycrawlers
  module Storage
    #
    # The null storage.
    #
    # This storage is useful for test.
    #
    class Null < Base

      #
      # Save nothing
      #
      def save(url, headers, body)
      end

      #
      # Find nothing
      #
      def find(url)
      end
    end
  end
end
