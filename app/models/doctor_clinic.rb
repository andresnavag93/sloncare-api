class DoctorClinic < ApplicationRecord
  validate :doctor_or_clinic_distinct_and_not_null
  belongs_to :doctor, :class_name => 'UserAccess'
  belongs_to :clinic, :class_name => 'UserAccess'
  validates :doctor_id, uniqueness: { scope: :clinic_id, message: 51 }

  def doctor_or_clinic_distinct_and_not_null
    if doctor == nil or clinic == nil 
      errors.add(:doctor_clinic, (I18n.t 'custom_errors.doctor_clinic.1'))
    elsif doctor.access_id != 70 
      errors.add(:doctor_clinic, (I18n.t 'custom_errors.doctor_clinic.2'))
    elsif clinic.access_id != 71
      errors.add(:doctor_clinic, (I18n.t 'custom_errors.doctor_clinic.3'))
    end
  end
  
end
