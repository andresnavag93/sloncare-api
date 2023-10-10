class CreateSpecialties < ActiveRecord::Migration[5.2]
  def change
    create_table :specialties do |t|
      t.references :specialty, foreign_key: true
      t.string :name
      t.string :name_en
      t.boolean :base, default: false
      t.boolean :provider, default: false

      t.timestamps
    end
  end
end
