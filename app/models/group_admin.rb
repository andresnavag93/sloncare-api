class GroupAdmin < ApplicationRecord
  validate :group_or_admin_not_null
  belongs_to :group
  belongs_to :admin, :class_name => 'UserAccess'
  validates :group_id, uniqueness: { scope: :admin_id, message: 51 }

  def group_or_admin_not_null
    if group == nil or admin == nil
        errors.add(:group_admin, (I18n.t 'custom_errors.group_admin.1'))
    elsif admin.access_id != 72 
      errors.add(:group_beneficiary,  (I18n.t 'custom_errors.group_admin.2'))
    end
  end

end
