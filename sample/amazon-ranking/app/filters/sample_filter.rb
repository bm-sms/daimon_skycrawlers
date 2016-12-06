require "daimon_skycrawlers/filter/base"

class SampleFilter < DaimonSkycrawlers::Filter::Base
  def call(message)
    # Imprement your filter here.
    # If you want to crawl `url`, return true otherwise false.
    true
  end
end
