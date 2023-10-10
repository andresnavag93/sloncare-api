class UserSpecialty < ApplicationRecord
  validate :user_or_specialty_not_null
  belongs_to :user_access
  belongs_to :specialty
  belongs_to :subspecialty, :class_name => 'Specialty', optional: true
  has_many :user_tabs, dependent: :destroy
  validates :user_access_id, uniqueness: { scope: :specialty_id, message: 51 }

  def user_or_specialty_not_null
    if specialty == nil or user_access == nil
        errors.add(:user_specialty, "User and Specialty cannot be null")
    elsif user_access.access_id != 70 and user_access.access_id != 71 and user_access.access_id != 74
      errors.add(:user_specialty, "Access distinct to Doctor o Clinic")
    end
  end

end
