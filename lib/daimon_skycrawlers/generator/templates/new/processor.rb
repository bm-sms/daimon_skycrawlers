#!/usr/bin/env ruby

require "daimon_skycrawlers/processor"

require_relative "./init"

DaimonSkycrawlers.register_processor do |data|
  p "It works with '#{data[:url]}'"
end

DaimonSkycrawlers::Processor.run
