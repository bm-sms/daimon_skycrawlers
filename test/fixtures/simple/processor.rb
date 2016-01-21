require 'bundler/setup'
require 'daimon_skycrawlers'

p '* Processor', DaimonSkycrawlers::VERSION

DaimonSkycrawlers.register_processor do |url, header, body|
  p '* process!', url
end

DaimonSkycrawlers.run :processor
