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
      # Read nothing
      #
      def read(message = {})
      end
    end
  end
end
