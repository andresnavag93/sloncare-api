class UserAccessClinicSerializer < ActiveModel::Serializer
  attributes :id, :wallet_id, :access_id, :visibility, :is_active
  has_one :user, serializer: ClinicOneSerializer 
  has_one :wallet
  has_many :specialties

  def wallet
    object.wallet
  end

  def specialties
    n = 1
    for obj in object.specialties.order( "name ASC" )
      obj._id = n
      obj._name = obj.name
      n += 1
    end
  end

end
