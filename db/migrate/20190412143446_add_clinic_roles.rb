class AddClinicRoles < ActiveRecord::Migration[5.2]
    def change
      add_column :users, :clinic_role_id, :integer, :default => 1
    end
  end