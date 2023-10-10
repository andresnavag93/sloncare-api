class CreateGroupAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :group_admins do |t|
      t.references :group, foreign_key: true
      t.references :admin

      t.timestamps
    end

    add_foreign_key :group_admins, :user_accesses, column: :admin_id, primary_key: :id
    add_index :group_admins, [:group_id, :admin_id], unique: true
  end
end
