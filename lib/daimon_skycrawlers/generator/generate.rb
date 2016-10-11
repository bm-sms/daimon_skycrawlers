require "thor"
require "daimon_skycrawlers/generator/crawler"
require "daimon_skycrawlers/generator/processor"

module DaimonSkycrawlers
  module Generator
    class Generate < Thor
      register(Crawler, "crawler", "crawler NAME", "Generate new crawler")
      register(Processor, "processor", "processor NAME", "Generate new processor")
    end
  end
end
