require "active_record"

ActiveRecord::Base.establish_connection(adapter: "sqlite3",
                                        database: "storage.db")

ActiveRecord::Schema.define(version: 1) do
  create_table :pages do |t|
    t.string :url
    t.text :headers
    t.binary :body, limit: 10 * 1024 ** 2 # 10MiB
    t.datetime :last_modified_at
    t.string :etag
    t.timestamps
  end
end
