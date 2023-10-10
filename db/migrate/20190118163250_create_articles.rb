class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :description
      t.string :picture
      t.references :locale

      t.timestamps
    end
    add_foreign_key :articles, :tbl_attributes, column: :locale_id, primary_key: :id
  end
end
