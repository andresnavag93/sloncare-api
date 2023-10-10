class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.references :wallet, foreign_key: true
      t.references :plan
      t.references :saving_level
      t.decimal :savings, default: 0
      t.boolean :is_active, default: true
      t.integer :b_count
      t.integer :a_count
      t.string :customer_id
      t.string :c_name
      t.string :c_lastname
      t.string :c_document
      t.string :c_rif
      t.integer :c_rifnumber
      t.string :c_email
      t.string :c_localphone
      t.string :c_cellphone
      t.string :c1_name
      t.string :c1_lastname
      t.string :c1_workstation
      t.string :c1_localphone
      t.string :c1_cellphone
      t.string :c1_email
      t.string :c2_name
      t.string :c2_lastname
      t.string :c2_workstation
      t.string :c2_localphone
      t.string :c2_cellphone
      t.string :c2_email
      t.string :line_1
      t.string :line_2
      t.references :country
      t.references :state
      t.references :city
      t.integer :zipcode
      t.references :locale

      t.timestamps
    end

    add_foreign_key :groups, :tbl_attributes, column: :locale_id, primary_key: :id
    add_foreign_key :groups, :locations, column: :country_id, primary_key: :id
    add_foreign_key :groups, :locations, column: :state_id, primary_key: :id
    add_foreign_key :groups, :locations, column: :city_id, primary_key: :id
    add_foreign_key :groups, :tbl_attributes, column: :plan_id, primary_key: :id
    add_foreign_key :groups, :tbl_attributes, column: :saving_level_id, primary_key: :id
  end
end
