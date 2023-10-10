class AddCountriesCodesAndBankInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :cc_localphone, :integer, :default => 58
    add_column :groups, :cc_c1_localphone, :integer, :default => 58
    add_column :groups, :cc_c2_localphone, :integer, :default => 58
    add_column :groups, :cc_cellphone, :integer, :default => 58
    add_column :groups, :cc_c1_cellphone, :integer, :default => 58
    add_column :groups, :cc_c2_cellphone, :integer, :default => 58
    add_column :users, :cc_localphone, :integer, :default => 58
    add_column :users, :cc_c1_localphone, :integer, :default => 58
    add_column :users, :cc_c2_localphone, :integer, :default => 58
    add_column :users, :cc_cellphone, :integer, :default => 58
    add_column :users, :cc_c1_cellphone, :integer, :default => 58
    add_column :users, :cc_c2_cellphone, :integer, :default => 58
    add_column :transacs, :zelle, :string
    add_column :transacs, :bank_name, :string
    add_column :transacs, :account, :string
    add_column :transacs, :comments, :string
    add_column :transacs, :swift, :string
    add_column :transacs, :aba, :string
  end
end