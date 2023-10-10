class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :lastname
      t.string :businessname
      t.string :localphone
      t.string :cellphone
      t.string :rif
      t.integer :rifnumber
      t.string :document
      t.string :d_name
      t.string :d_lastname
      t.string :d_document
      t.string :d_phone
      t.string :d_email
      t.string :d_picture
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
      t.string :mh_permit
      t.string :ms_id
      t.string :nationality
      t.string :picture
      t.string :email
      t.string :password
      t.string :profession
      t.string :aq_1
      t.string :aq_2
      t.string :line_1
      t.string :line_2
      t.integer :zipcode
      t.string :customer_id
      t.decimal :savings, default: 0
      t.date :birthday
      t.float :weight
      t.float :size
      t.references :country
      t.references :state
      t.references :city
      t.references :plan
      t.references :saving_level
      t.references :locale
      t.references :sq_1
      t.references :sq_2
      t.references :blood_type
      t.references :race
      t.references :weight_unit
      t.references :size_unit
      t.references :gender

      t.string :mh_permit_id
      t.string :subespecialty_field

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_foreign_key :users, :tbl_attributes, column: :locale_id, primary_key: :id
    add_foreign_key :users, :locations, column: :country_id, primary_key: :id
    add_foreign_key :users, :locations, column: :state_id, primary_key: :id
    add_foreign_key :users, :locations, column: :city_id, primary_key: :id
    add_foreign_key :users, :tbl_attributes, column: :plan_id, primary_key: :id
    add_foreign_key :users, :tbl_attributes, column: :saving_level_id, primary_key: :id
    add_foreign_key :users, :tbl_attributes, column: :sq_1_id, primary_key: :id
    add_foreign_key :users, :tbl_attributes, column: :sq_2_id, primary_key: :id
    add_foreign_key :users, :tbl_attributes, column: :blood_type_id, primary_key: :id
    add_foreign_key :users, :tbl_attributes, column: :race_id, primary_key: :id
    add_foreign_key :users, :tbl_attributes, column: :weight_unit_id, primary_key: :id
    add_foreign_key :users, :tbl_attributes, column: :size_unit_id, primary_key: :id
    add_foreign_key :users, :tbl_attributes, column: :gender_id, primary_key: :id
  end
end
