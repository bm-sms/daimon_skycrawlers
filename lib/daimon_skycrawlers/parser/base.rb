module DaimonSkycrawlers
  module Parser
    class Base
      def initialize(html)
        @html = html
      end

      def parse
        raise "Implement this method in subclass"
      end
    end
  end
end
