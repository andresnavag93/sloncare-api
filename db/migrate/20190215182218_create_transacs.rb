class CreateTransacs < ActiveRecord::Migration[5.2]
  def change
    create_table :transacs do |t|
      t.boolean :income
      t.boolean :outcome
      t.decimal :amount, default: 0
      t.string :description
      t.references :wallet, foreign_key: true
      t.references :pay_wallet
      t.references :service_order, foreign_key: true #NEW
      t.references :transac_type #NEW
      t.references :currency
      t.references :transac, foreign_key: true
      t.boolean :checked, default: true

      t.timestamps
    end
    add_foreign_key :transacs, :wallets, column: :pay_wallet_id, primary_key: :id
    add_foreign_key :transacs, :tbl_attributes, column: :transac_type_id, primary_key: :id
    add_foreign_key :transacs, :tbl_attributes, column: :currency_id, primary_key: :id
    #execute "SELECT setval('transacs_id_seq', 101000)"
  end
end
