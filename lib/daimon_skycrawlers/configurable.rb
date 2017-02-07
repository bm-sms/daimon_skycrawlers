module DaimonSkycrawlers
  #
  # This module provides `#configure` to construct instance
  #
  module Configurable
    #
    # Configure instance
    #
    # @yield [instance] give instance to the block
    # @yieldparam instance [DaimonSkycrawlers::Crawler::Base|DaimonSkycrawlers::Processor::Base] self
    # @return [DaimonSkycrawlers::Crawler::Base|DaimonSkycrawlers::Processor::Base] self
    #
    def configure
      yield self
      self
    end
  end
end
