class UserAccessBeneficiarySerializer < ActiveModel::Serializer
  attributes :id, :wallet_id, :access_id
  has_one :user, serializer: BeneficiaryOneSerializer
  has_one :wallet
  has_many :protocols, serializer: ProtocolSerializer

  def wallet
    object.wallet
  end

  def protocols
    objs = TblAttribute.where("tbl_attribute_id = 6")
    active_protocols = object.wallet.protocols
    no_active_protocols = objs - active_protocols    
    active_protocols.each do |p|
      p.is_active = true
    end
    no_active_protocols.each do |p|
      p.is_active = false
    end
    return active_protocols + no_active_protocols
  end

  # def protocols
  # 	begin
  # 		return Gets::protocols(object)
  # 	rescue
  # 		return []
  # 	end
  # end
end
