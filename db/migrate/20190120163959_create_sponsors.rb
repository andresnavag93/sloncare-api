class CreateSponsors < ActiveRecord::Migration[5.2]
  def change
    create_table :sponsors do |t|
      t.string :email
      t.string :name
      t.string :phone
      t.string :document
      t.references :country
      t.string :country_code

      t.timestamps
    end
    add_foreign_key :sponsors, :locations, column: :country_id, primary_key: :id
    add_index :sponsors, :email, unique: true
  end
end
