class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :url, index: true
      t.text :headers
      t.binary :body
      t.datetime :last_modified_at
      t.string :etag

      t.timestamps

      t.index [:url, :updated_at]
    end
  end
end
