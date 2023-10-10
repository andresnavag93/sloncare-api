class Beneficiary < User
  belongs_to :saving_level, :class_name => 'TblAttribute'
  belongs_to :blood_type, :class_name => 'TblAttribute'
  belongs_to :race, :class_name => 'TblAttribute'
  belongs_to :weight_unit, :class_name => 'TblAttribute'
  belongs_to :size_unit, :class_name => 'TblAttribute'
  belongs_to :gender, :class_name => 'TblAttribute'
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
  #  if (self.localphone and !/\A\d{10,}\z/.match?(self.localphone)) or
  #   (self.cellphone and !/\A\d{10,}\z/.match?(self.cellphone)) or
  #   (self.c1_localphone and !/\A\d{10,}\z/.match?(self.c1_localphone)) or
  #   (self.c1_cellphone and !/\A\d{10,}\z/.match?(self.c1_cellphone)) or
  #   (self.c2_localphone and !/\A\d{10,}\z/.match?(self.c2_localphone)) or 
  #   (self.c2_cellphone and !/\A\d{10,}\z/.match?(self.c2_cellphone))
  #    errors.add( :savings, (I18n.t 'custom_errors.global.2'))
  #  end
  #end 

end