class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :url, index: true
      t.text :headers
      t.binary :body, limit: 10 * 1024 ** 2 # 10MiB
      t.datetime :last_modified_at
      t.string :etag

      t.timestamps null: false

      t.index [:url, :updated_at], using: :btree
    end
  end
end
