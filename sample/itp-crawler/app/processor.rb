require "daimon_skycrawlers"
require "daimon_skycrawlers/processor"
require "daimon_skycrawlers/processor/base"

DaimonSkycrawlers.load_processors

processor = ItpProcessor.new
DaimonSkycrawlers.register_processor(processor)
