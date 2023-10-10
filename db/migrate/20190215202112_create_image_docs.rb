class CreateImageDocs < ActiveRecord::Migration[5.2]
  def change
    create_table :image_docs do |t|
      t.references :service_order, foreign_key: true
      t.string :name
      t.references :image_type

      t.timestamps
    end
    add_foreign_key :image_docs, :tbl_attributes, column: :image_type_id, primary_key: :id
  end
end
