class User < ApplicationRecord
  attr_accessor :_id, :_name
  belongs_to :sq_1, :class_name => 'TblAttribute'
  belongs_to :sq_2, :class_name => 'TblAttribute'
  belongs_to :locale, :class_name => 'TblAttribute'
  belongs_to :country, :class_name => 'Location', optional: true
  belongs_to :state, :class_name => 'Location', optional: true
  belongs_to :city, :class_name => 'Location', optional: true
  belongs_to :plan, :class_name => 'TblAttribute', optional: true
  belongs_to :saving_level, :class_name => 'TblAttribute', optional: true
  belongs_to :blood_type, :class_name => 'TblAttribute', optional: true
  belongs_to :race, :class_name => 'TblAttribute', optional: true
  belongs_to :weight_unit, :class_name => 'TblAttribute', optional: true
  belongs_to :size_unit, :class_name => 'TblAttribute', optional: true
  belongs_to :gender, :class_name => 'TblAttribute', optional: true
  has_many :user_accesses, dependent: :destroy
  validates :email, uniqueness: { message: :uniqueness }, 
    email_format: { message: :email_format }, presence: { message: :presence }
  validates :aq_1, presence: { message: :presence }
  validates :aq_2, presence: { message: :presence }
  validates :password, presence: { message: :presence }
end
