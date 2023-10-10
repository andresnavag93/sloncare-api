class ServiceOrder < ApplicationRecord
  belongs_to :service_type, :class_name => 'TblAttribute'
  belongs_to :specialty, optional: true
  belongs_to :subspecialty, :class_name => 'Specialty', optional: true
  belongs_to :status, :class_name => 'TblAttribute'
  belongs_to :priority, :class_name => 'TblAttribute', optional: true
  belongs_to :country, :class_name => 'Location', optional: true
  belongs_to :state, :class_name => 'Location', optional: true
  belongs_to :city, :class_name => 'Location', optional: true
  belongs_to :beneficiary, :class_name => 'UserAccess'
  belongs_to :provider, :class_name => 'UserAccess'
  belongs_to :income, :class_name => 'TblAttribute', optional: true
  belongs_to :assigned_area, :class_name => 'TblAttribute', optional: true
  belongs_to :high, :class_name => 'TblAttribute', optional: true
  belongs_to :group, optional: true
  belongs_to :currency, :class_name => 'TblAttribute', optional: true
  has_many :items, dependent: :destroy
  has_many :image_docs, dependent: :destroy
  has_many :order_records, dependent: :destroy
  has_one :transac, dependent: :nullify 


  has_many :tabulators, through: :items
  
end
