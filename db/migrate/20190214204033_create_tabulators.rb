class CreateTabulators < ActiveRecord::Migration[5.2]
  def change
    create_table :tabulators do |t|
      t.references :service_type
      t.references :specialty, foreign_key: true
      t.references :subspecialty#, foreign_key: true
      t.decimal :suggested_price, default: 0
      t.string :name
      t.text :description

      t.timestamps
    end
    add_foreign_key :tabulators, :tbl_attributes, column: :service_type_id, primary_key: :id
    add_foreign_key :tabulators, :specialties, column: :subspecialty_id, primary_key: :id
  end
end
