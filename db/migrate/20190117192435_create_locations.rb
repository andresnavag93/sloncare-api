class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :value
      t.string :name_en
      t.string :value_en
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
