class CreateSloncodes < ActiveRecord::Migration[5.2]
  def change
    create_table :sloncodes do |t|
      t.string :p_reference
      t.string :code
      t.decimal :fee, default: 0
      t.decimal :price, default: 0
      t.references :encrypt
      t.references :payment
      t.references :transac, foreign_key: true
      t.references :currency

      t.timestamps
    end
    add_index :sloncodes, :code, unique: true
    add_index :sloncodes, :p_reference, unique: true
    add_foreign_key :sloncodes, :tbl_attributes, column: :encrypt_id, primary_key: :id
    add_foreign_key :sloncodes, :tbl_attributes, column: :payment_id, primary_key: :id
    add_foreign_key :sloncodes, :tbl_attributes, column: :currency_id, primary_key: :id
  end
end
