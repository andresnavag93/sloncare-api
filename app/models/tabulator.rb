class Tabulator < ApplicationRecord
  attr_accessor :_id, :_name
  belongs_to :service_type, :class_name => 'TblAttribute'
  belongs_to :subspecialty, :class_name => 'Specialty', optional: true
  belongs_to :specialty, optional: true

  has_many :user_tabs, dependent: :destroy
  has_many :items, dependent: :destroy

end

