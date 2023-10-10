class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.decimal :balance, default: 0
      t.decimal :deferred, default: 0
      t.decimal :available, default: 0
      t.integer :code
      t.datetime :code_expires

      t.timestamps
    end
    #execute "SELECT setval('wallets_id_seq', 101000)"
    
  end
end
