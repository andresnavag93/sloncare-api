class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :description
      t.references :access

      t.timestamps
    end
    add_foreign_key :notifications, :tbl_attributes, column: :access_id, primary_key: :id
  end
end
