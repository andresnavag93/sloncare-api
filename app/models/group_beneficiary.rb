class GroupBeneficiary < ApplicationRecord
  attr_accessor :name, :lastname, :wallet_id, :email, :document
  validate :group_or_beneficiary_not_null
  belongs_to :group
  belongs_to :beneficiary, :class_name => 'UserAccess'
  validates :group_id, uniqueness: { scope: :beneficiary_id, message: 51 }

  def group_or_beneficiary_not_null
    if group == nil or beneficiary == nil
        errors.add(:group_beneficiary, (I18n.t 'custom_errors.group_beneficiary.1'))
    elsif beneficiary.access_id != 69 
      errors.add(:group_beneficiary, (I18n.t 'custom_errors.group_beneficiary.2'))
    end
  end
end
