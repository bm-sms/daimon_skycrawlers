require "thor"
require "daimon_skycrawlers/generator/crawler"
require "daimon_skycrawlers/generator/processor"
require "daimon_skycrawlers/generator/filter"

module DaimonSkycrawlers
  module Generator
    class Generate < Thor
      register(Crawler, "crawler", "crawler NAME", "Generate new crawler")
      register(Processor, "processor", "processor NAME", "Generate new processor")
      register(Filter, "filter", "filter NAME", "Generate new filter")
    end
  end
end
