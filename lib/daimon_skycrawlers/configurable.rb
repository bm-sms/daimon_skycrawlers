module DaimonSkycrawlers
  module Configurable
    #
    # Configure spider instance
    #
    # @return [DaimonSkycrawlers::Crawler::Base|DaimonSkycrawlers::Processor::Base] self
    #
    def configure
      yield self
      self
    end
  end
end
