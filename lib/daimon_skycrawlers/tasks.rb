load "active_record/railties/databases.rake"
load "daimon_skycrawlers/tasks/database_tasks.rake"

ActiveRecord::Base.configurations = YAML.load_file("config/database.yml")
