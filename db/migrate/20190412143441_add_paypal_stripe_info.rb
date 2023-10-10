class AddPaypalStripeInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :transacs, :paypal, :string
    add_column :transacs, :stripe, :string
  end
end