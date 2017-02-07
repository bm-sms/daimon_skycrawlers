module DaimonSkycrawlers
  module ConfigMixin
    # @private
    def initialize
      super
      @log = DaimonSkycrawlers.configuration.logger
    end
  end
end
