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
      def save(data)
      end

      #
      # Find nothing
      #
      def find(url, message = {})
      end
    end
  end
end
