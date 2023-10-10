class Specialty < ApplicationRecord
  attr_accessor :_id, :_name
  validate :specialty_foreign_key_not_equal_to_id
  belongs_to :specialty, optional: true
  has_many :tabulators, dependent: :destroy
  has_many :user_specialties, dependent: :destroy

  def specialty_foreign_key_not_equal_to_id
    if specialty != nil and specialty.id == id 
        errors.add(:specialty, "Foreign key cannot be the same  as id")
    end
  end
end
