class TblAttribute < ApplicationRecord
  attr_accessor :is_active, :percentage
  validate :tbl_attribute_foreign_key_not_equal_to_id
  belongs_to :tbl_attribute, optional: true

  def tbl_attribute_foreign_key_not_equal_to_id
    if tbl_attribute != nil and tbl_attribute.id == id 
        errors.add(:tbl_attribute, "Foreign key cannot be the same  as id")
    end
  end
end
