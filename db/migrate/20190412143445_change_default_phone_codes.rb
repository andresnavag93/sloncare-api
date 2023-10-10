class ChangeDefaultPhoneCodes < ActiveRecord::Migration[5.2]
  def change
    change_column :sponsors, :cc_phone, :integer, :default => nil
    change_column :locations, :cc, :integer, :default => nil
    change_column :groups, :cc_localphone, :integer, :default => nil
    change_column :groups, :cc_c1_localphone, :integer, :default => nil
    change_column :groups, :cc_c2_localphone, :integer, :default => nil
    change_column :groups, :cc_cellphone, :integer, :default => nil
    change_column :groups, :cc_c1_cellphone, :integer, :default => nil
    change_column :groups, :cc_c2_cellphone, :integer, :default => nil
    change_column :users, :cc_d_phone, :integer, :default => nil
    change_column :users, :cc_localphone, :integer, :default => nil
    change_column :users, :cc_c1_localphone, :integer, :default => nil
    change_column :users, :cc_c2_localphone, :integer, :default => nil
    change_column :users, :cc_cellphone, :integer, :default => nil
    change_column :users, :cc_c1_cellphone, :integer, :default => nil
    change_column :users, :cc_c2_cellphone, :integer, :default => nil
  end
end