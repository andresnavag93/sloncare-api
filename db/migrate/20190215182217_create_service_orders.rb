class CreateServiceOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :service_orders do |t|
      t.references :service_type
      t.references :specialty, foreign_key: true
      t.references :subspecialty#, foreign_key: true
      t.references :status
      t.references :priority
      t.references :country
      t.references :state
      t.references :city
      t.references :beneficiary
      #t.date :o_possible_appointment_date
      t.date :o_appointment_date
      t.references :provider
      t.string :reason_for_admission
      t.text :symptom
      t.decimal :total_suggested, default: 0
      t.decimal :total, default: 0
      t.text :b_observations
      t.text :p_observations
      t.references :income
      t.boolean :livelihood, default: false
      t.references :assigned_area
      t.integer :room_number
      t.text :recipe
      t.text :indications
      t.text :recipe_comments
      t.text :indications_comments
      t.text :medical_report
      t.text :diagnosis
      t.text :evolutionary_report
      t.references :high
      t.text :egress_report
      t.datetime :egress_date
      t.datetime :entry_date
      t.references :group, foreign_key: true #NEW
      t.references :currency #NEW

      t.timestamps
    end

    add_foreign_key :service_orders, :user_accesses, column: :beneficiary_id, primary_key: :id
    add_foreign_key :service_orders, :user_accesses, column: :provider_id, primary_key: :id
    add_foreign_key :service_orders, :tbl_attributes, column: :service_type_id, primary_key: :id
    add_foreign_key :service_orders, :tbl_attributes, column: :status_id, primary_key: :id
    add_foreign_key :service_orders, :tbl_attributes, column: :priority_id, primary_key: :id
    add_foreign_key :service_orders, :locations, column: :country_id, primary_key: :id
    add_foreign_key :service_orders, :locations, column: :state_id, primary_key: :id
    add_foreign_key :service_orders, :locations, column: :city_id, primary_key: :id
    add_foreign_key :service_orders, :tbl_attributes, column: :income_id, primary_key: :id
    add_foreign_key :service_orders, :tbl_attributes, column: :assigned_area_id, primary_key: :id
    add_foreign_key :service_orders, :tbl_attributes, column: :high_id, primary_key: :id
    add_foreign_key :service_orders, :specialties, column: :subspecialty_id, primary_key: :id
    add_foreign_key :service_orders, :tbl_attributes, column: :currency_id, primary_key: :id

  end
end
