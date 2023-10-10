class AddLoginTries < ActiveRecord::Migration[5.2]
  def change
    add_column :user_accesses, :login_tries, :integer, :default => 0
    add_column :user_accesses, :try_expires, :datetime
  end
end
