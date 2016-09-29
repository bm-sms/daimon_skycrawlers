require "daimon_skycrawlers/processor"

DaimonSkycrawlers.register_processor do |data|
  p "It works with '#{data[:url]}'"
end
