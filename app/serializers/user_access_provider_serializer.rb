class UserAccessProviderSerializer < ActiveModel::Serializer
  attributes :id, :wallet_id, :access_id, :visibility, :is_active, :specialty_id
  has_one :user, serializer: ProviderOneSerializer 
  has_one :wallet
  has_one :specialty, serializer: SpecialtySerializer

  def wallet
    object.wallet
  end

  def specialty_id
    object.user_specialties.first.specialty_id
  end

  def specialty
    object.user_specialties.first.specialty
  end

end