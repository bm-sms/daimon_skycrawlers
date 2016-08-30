module DaimonSkycrawlers
  module ConfigMixin
    def initialize
      super
      @config = DaimonSkycrawlers.configuration
      @log = @config.logger
    end

    class << self
      def included(base)
        base.module_eval do
          attr_reader :config
        end
      end
    end
  end
end
