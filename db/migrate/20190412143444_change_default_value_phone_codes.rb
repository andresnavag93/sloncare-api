class ChangeDefaultValuePhoneCodes < ActiveRecord::Migration[5.2]
  def change
    change_column :sponsors, :cc_phone, :integer, :null => true
    change_column :locations, :cc, :integer, :null => true
    change_column :groups, :cc_localphone, :integer, :null => true
    change_column :groups, :cc_c1_localphone, :integer, :null => true
    change_column :groups, :cc_c2_localphone, :integer, :null => true
    change_column :groups, :cc_cellphone, :integer, :null => true
    change_column :groups, :cc_c1_cellphone, :integer, :null => true
    change_column :groups, :cc_c2_cellphone, :integer, :null => true
    change_column :users, :cc_d_phone, :integer, :null => true
    change_column :users, :cc_localphone, :integer, :null => true
    change_column :users, :cc_c1_localphone, :integer, :null => true
    change_column :users, :cc_c2_localphone, :integer, :null => true
    change_column :users, :cc_cellphone, :integer, :null => true
    change_column :users, :cc_c1_cellphone, :integer, :null => true
    change_column :users, :cc_c2_cellphone, :integer, :null => true
  end
end