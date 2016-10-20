class CreateShop < ActiveRecord::Migration[5.0]
  def change
    create_table :shops do |t|
      t.string :name, index: true
      t.text :description
      t.string :itp_url, index: true
      t.string :zip_code
      t.string :address
      t.string :phone

      t.timestamps
    end
  end
end
