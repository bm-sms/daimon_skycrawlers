module DaimonSkycrawlers
  #
  # Name space for storage
  #
  module Storage
  end
end

require "daimon_skycrawlers/storage/base"
require "daimon_skycrawlers/storage/rdb"
require "daimon_skycrawlers/storage/null"
require "daimon_skycrawlers/storage/file"
