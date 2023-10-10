class Location < ApplicationRecord
  attr_accessor :is_active, :percentage
  validate :location_foreign_key_not_equal_to_id
  belongs_to :location, optional: true

  def location_foreign_key_not_equal_to_id
    if location != nil and location.id == id 
        errors.add(:location, (I18n.t 'custom_errors.location.1'))
    end
  end

end
