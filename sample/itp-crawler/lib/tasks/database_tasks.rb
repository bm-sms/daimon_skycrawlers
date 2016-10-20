require "daimon_skycrawlers"

seed_loader = Class.new do
  def load_seed
    # load "#{ActiveRecord::Tasks::DatabaseTasks.db_dir}/seeds.rb"
  end
end

namespace :itp do
  namespace :db do |ns|
    task :drop => [:load_config] do
      ActiveRecord::Tasks::DatabaseTasks.drop_current
    end

    task :create => [:load_config] do
      ActiveRecord::Tasks::DatabaseTasks.create_current
    end

    task :migrate => [:load_config] do
      ActiveRecord::Tasks::DatabaseTasks.migrate
      ns["_dump"].invoke
    end

    task :_dump do
      ns["schema:dump"].invoke
      ns["_dump"].reenable
    end

    task :version => [:load_config] do
      puts "Current version: #{ActiveRecord::Migrator.current_version}"
    end

    namespace :migrate do
      task :reset => ["db:drop", "db:create", "db:migrate"]
    end

    namespace :schema do
      task :dump => [:load_config] do
        require "active_record/schema_dumper"
        filename = ENV["SCHEMA"] || File.join(ActiveRecord::Tasks::DatabaseTasks.db_dir, "schema.rb")
        File.open(filename, "w:utf-8") do |file|
          ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
        end
        ns["schema:dump"].reenable
      end

      task :load => [:load_config] do
        ActiveRecord::Tasks::DatabaseTasks.load_schema_current(:ruby, ENV["SCHEMA"])
      end
    end

    task :load_config do
      ActiveRecord::Tasks::DatabaseTasks.tap do |config|
        config.root                   = Rake.application.original_dir
        config.env                    = ENV["SKYCRAWLERS_ENV"] || "development"
        config.db_dir                 = "db_itp"
        config.migrations_paths       = ["db_itp/migrate"]
        config.fixtures_path          = "test/fixtures"
        config.seed_loader            = seed_loader.new
        config.database_configuration = YAML.load_file("config/database_itp.yml")
      end
      ActiveRecord::Base.configurations = YAML.load_file("config/database_itp.yml")
      ActiveRecord::Base.establish_connection(DaimonSkycrawlers.env.to_sym)
    end
  end
end
