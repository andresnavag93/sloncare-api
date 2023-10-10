class CreateDoctorClinics < ActiveRecord::Migration[5.2]
  def change
    create_table :doctor_clinics do |t|
      t.references :doctor
      t.references :clinic

      t.timestamps
    end

    add_foreign_key :doctor_clinics, :user_accesses, column: :doctor_id, primary_key: :id
    add_foreign_key :doctor_clinics, :user_accesses, column: :clinic_id, primary_key: :id
    add_index :doctor_clinics, [:doctor_id, :clinic_id], unique: true
  end
end
