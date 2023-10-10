class CreateUserSpecialties < ActiveRecord::Migration[5.2]
  def change
    create_table :user_specialties do |t|
      t.references :user_access, foreign_key: true
      t.references :specialty, foreign_key: true
      t.references :subspecialty#, foreign_key: true

      t.timestamps
    end
    add_index :user_specialties, [:specialty_id, :user_access_id], unique: true
    add_foreign_key :user_specialties, :specialties, column: :subspecialty_id, primary_key: :id
  end
end
