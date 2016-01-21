require 'bundler/setup'
require 'daimon_skycrawlers'

p '* Processor', DaimonSkycrawlers::VERSION

DaimonSkycrawlers.register_processor do |data|
  p '* process!', data[:url]
end

DaimonSkycrawlers.scheduler.run
