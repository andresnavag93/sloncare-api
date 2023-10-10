class CreateUserAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :user_accesses do |t|
      t.references :access
      t.references :user, foreign_key: true
      t.boolean :is_active, default: false
      t.boolean :visibility, default: false
      t.references :wallet, foreign_key: true
      t.string :auth_token
      t.string :verify_token
      t.integer :verification_code
      t.datetime :code_expires

      t.timestamps
    end

    add_foreign_key :user_accesses, :tbl_attributes, column: :access_id, primary_key: :id
    add_index :user_accesses, [:user_id, :access_id], unique: true
  end
end
