class AddMoreAdditionalBankInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :transacs, :holder_email, :string
    add_column :transacs, :holder_name, :string
    add_column :transacs, :address, :string
  end
end