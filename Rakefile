require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"
require "daimon_skycrawlers/tasks"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
  t.verbose = false
  t.warning = false
end

task :default => [:test]
