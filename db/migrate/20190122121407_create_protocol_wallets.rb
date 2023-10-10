class CreateProtocolWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :protocol_wallets do |t|
      t.references :wallet, foreign_key: true
      t.references :protocol
      t.float :percentage, default: 0

      t.timestamps
    end

    add_foreign_key :protocol_wallets, :tbl_attributes, column: :protocol_id, primary_key: :id
    add_index :protocol_wallets, [:protocol_id, :wallet_id], unique: true
  end
end
