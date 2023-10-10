class CreateUserTabs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tabs do |t|
      t.references :user_specialty, foreign_key: true
      t.references :tabulator, foreign_key: true

      t.timestamps
    end
    add_index :user_tabs, [:tabulator_id, :user_specialty_id], unique: true
  end
end
