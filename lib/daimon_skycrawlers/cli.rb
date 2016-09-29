require "thor"
require "daimon_skycrawlers/generator/new"
require "daimon_skycrawlers/commands/runner"
require "daimon_skycrawlers/version"

module DaimonSkycrawlers
  class CLI < Thor
    register(Generator::New, "new", "new NAME", "Create new project")
    register(Commands::Runner, "exec", "exec [COMMAND]", "Execute crawler/processor")

    desc "version", "Show version"
    def version
      puts VERSION
    end
  end
end
