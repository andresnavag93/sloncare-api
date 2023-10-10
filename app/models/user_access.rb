class UserAccess < ApplicationRecord
  attr_accessor :_id, :_name
  validate :user_or_access_not_null
  belongs_to :access, :class_name => 'TblAttribute'
  belongs_to :user
  belongs_to :wallet, optional: true
  validates :user_id, uniqueness: { scope: :access_id, message: 51 }  
  has_many :user_specialties, dependent: :destroy
  has_many :specialties, through: :user_specialties
  has_many :provider_orders, :class_name => 'ServiceOrder', :foreign_key => 'provider_id'
  has_many :beneficiary_orders, :class_name => 'ServiceOrder', :foreign_key => 'beneficiary_id'
  has_many :group_admins, :class_name => 'GroupAdmin', :foreign_key => 'admin_id'

  def user_or_access_not_null
    if user == nil or access == nil 
        errors.add(:user_access, "User or Access cannot be null")
    elsif access.id == 72 and wallet != nil
        errors.add(:user_access, "Adminc with Access Group cannot have wallet")
    end
  end

end
