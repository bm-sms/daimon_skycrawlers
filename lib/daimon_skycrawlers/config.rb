module DaimonSkycrawlers
  module ConfigMixin
    def initialize
      super
      @log = DaimonSkycrawlers.configuration.logger
    end
  end
end
