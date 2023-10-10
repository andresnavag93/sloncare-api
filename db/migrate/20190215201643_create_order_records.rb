class CreateOrderRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :order_records do |t|
      t.references :service_order, foreign_key: true
      t.references :tabulator, foreign_key: true
      t.references :record
      t.decimal :price_end, default: 0
      t.string :title
      t.text :description
      t.string :record_name
      t.string :string
      t.integer :quantity, default: 0
      t.decimal :total, default: 0
      t.string :unit

      t.timestamps
    end
    add_foreign_key :order_records, :tbl_attributes, column: :record_id, primary_key: :id
  end
end
