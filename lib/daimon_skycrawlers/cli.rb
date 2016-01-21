require 'thor'
require 'daimon_skycrawlers/version'

module DaimonSkycrawlers
  class CLI < Thor
    desc "version", "Show version"
    def version
      puts VERSION
    end
  end
end
