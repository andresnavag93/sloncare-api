class Group < ApplicationRecord
  belongs_to :wallet, dependent: :destroy
  belongs_to :plan, :class_name => 'TblAttribute'
  belongs_to :saving_level, :class_name => 'TblAttribute'
  belongs_to :country, :class_name => 'Location', optional: true
  belongs_to :state, :class_name => 'Location', optional: true
  belongs_to :city, :class_name => 'Location', optional: true
  belongs_to :locale, :class_name => 'TblAttribute'
  has_many :group_beneficiaries, dependent: :destroy
  has_many :group_admins, dependent: :destroy
  validate :valid_savings
  #validate :valid_phones 

  def valid_savings
    if !self.savings
      errors.add( :savings, (I18n.t 'custom_errors.global.1'))
    else
      if self.savings < 0
        errors.add( :savings, (I18n.t 'custom_errors.global.1'))
      end
    end
  end

  #def valid_phones	
  #  if (self.c_localphone and !/\A\d{10,}\z/.match?(self.c_localphone)) or
  #   (self.c_cellphone and !/\A\d{10,}\z/.match?(self.c_cellphone)) or
  #   (self.c1_localphone and !/\A\d{10,}\z/.match?(self.c1_localphone)) or
  #   (self.c1_cellphone and !/\A\d{10,}\z/.match?(self.c1_cellphone)) or
  #   (self.c2_localphone and !/\A\d{10,}\z/.match?(self.c2_localphone)) or 
  #   (self.c2_cellphone and !/\A\d{10,}\z/.match?(self.c2_cellphone))
  #   	errors.add( :savings, (I18n.t 'custom_errors.global.2'))
  #  end
  #end 
end
