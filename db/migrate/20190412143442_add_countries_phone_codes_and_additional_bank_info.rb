class AddCountriesPhoneCodesAndAdditionalBankInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cc_d_phone, :integer, :default => 58
    add_column :sponsors, :cc_phone, :integer, :default => 58
    add_column :locations, :cc, :integer, :default => 58
    add_column :transacs, :country_name, :string
    add_column :transacs, :state_name, :string
    add_column :transacs, :city_name, :string
    add_column :transacs, :zipcode, :integer
  end
end