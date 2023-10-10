class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.integer :quantity
      t.decimal :price_init
      t.decimal :price_end
      t.boolean :checked
      t.references :tabulator, foreign_key: true
      t.references :service_order, foreign_key: true
      t.decimal :total

      t.timestamps
    end
  end
end
