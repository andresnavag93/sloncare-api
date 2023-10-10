class Transac < ApplicationRecord
  belongs_to :wallet, optional: true
  belongs_to :pay_wallet, :class_name => 'Wallet', optional: true
  belongs_to :service_order, optional: true
  belongs_to :transac_type, :class_name => 'TblAttribute', optional: true
  belongs_to :currency, :class_name => 'TblAttribute', optional: true
  belongs_to :service_order, optional: true
  belongs_to :transac, optional: true
  validate :foreign_key_equals

  def foreign_key_equals
    if wallet == pay_wallet 
        errors.add(:tbl_attribute, 47)
    end
  end

end
