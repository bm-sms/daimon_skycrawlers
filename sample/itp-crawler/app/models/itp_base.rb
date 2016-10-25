class ItpBase < ActiveRecord::Base
  self.abstract_class = true
  self.configurations = YAML.load_file("config/database_itp.yml")
  self.establish_connection(DaimonSkycrawlers.env.to_sym)
end
