class CreateSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :suggestions do |t|
      t.references :user_access, foreign_key: true
      t.string :email
      t.string :name
      t.text :description
      t.references :suggestion_type

      t.timestamps
    end
    add_foreign_key :suggestions, :tbl_attributes, column: :suggestion_type_id, primary_key: :id
  end
end
