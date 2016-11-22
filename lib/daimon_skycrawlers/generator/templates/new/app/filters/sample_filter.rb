require "daimon_skycrawlers/filter/base"

class SampleFilter < DaimonSkycrawlers::Filter::Base
  def call(url)
    # Imprement your filter here.
    # If you want to crawl `url`, return true otherwise false.
  end
end
