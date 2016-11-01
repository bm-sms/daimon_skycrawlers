# Copyright (c) 2012 Janko Marohnić
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# https://github.com/janko-m/sinatra-activerecord
#

seed_loader = Class.new do
  def load_seed
    # load "#{ActiveRecord::Tasks::DatabaseTasks.db_dir}/seeds.rb"
  end
end

# db:load_config can be overriden manually
Rake::Task["db:seed"].enhance(["db:load_config"])
Rake::Task["db:load_config"].clear

Rake::Task.define_task("db:environment")
Rake::Task.define_task("db:load_config") do
  ActiveRecord::Tasks::DatabaseTasks.tap do |config|
    config.root                   = Rake.application.original_dir
    config.env                    = ENV["SKYCRAWLERS_ENV"] || "development"
    config.db_dir                 = "db"
    config.migrations_paths       = ["db/migrate"]
    config.fixtures_path          = "test/fixtures"
    config.seed_loader            = seed_loader.new
    config.database_configuration = YAML.load(ERB.new(::File.read("config/database.yml")).result)
  end
  environment = ENV["SKYCRAWLERS_ENV"] || "development"
  ActiveRecord::Base.configurations = ActiveRecord::Tasks::DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection(environment.to_sym)
end
Rake::Task["db:test:deprecated"].clear if Rake::Task.task_defined?("db:test:deprecated")
