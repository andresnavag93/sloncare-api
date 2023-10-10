class CreateTblAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :tbl_attributes do |t|
      t.string :name
      t.string :value
      t.decimal :amount, default: 0
      t.string :name_en
      t.string :value_en
      t.references :tbl_attribute, foreign_key: true

      t.timestamps
    end
  end
end
