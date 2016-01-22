require 'thor'
require 'daimon_skycrawlers/generator/new'
require 'daimon_skycrawlers/version'

module DaimonSkycrawlers
  class CLI < Thor
    register(Generator::New, "new", "new NAME", "Create new project")

    desc "version", "Show version"
    def version
      puts VERSION
    end
  end
end
