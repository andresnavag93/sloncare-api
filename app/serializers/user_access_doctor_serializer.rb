class UserAccessDoctorSerializer < ActiveModel::Serializer
  attributes :id, :wallet_id, :access_id, :visibility, :is_active, :specialty_id, :subspecialty_id
  has_one :user, serializer: DoctorOneSerializer 
  has_one :wallet
  has_one :specialty, serializer: SpecialtySerializer
  has_one :subspecialty, serializer: SpecialtySerializer

  def wallet
    object.wallet
  end

  def specialty_id
    object.user_specialties.first.specialty_id
  end

  def specialty
    object.user_specialties.first.specialty
  end

  def subspecialty_id
    object.user_specialties.first.subspecialty_id
  end

  def subspecialty
    object.user_specialties.first.subspecialty
  end

  #has_many :clinics

  #def clinics
  #  n = 1
  #  for obj in object.clinics.order( "name ASC" )
  #    obj._id = n
  #    obj._name = obj.name
  #    n += 1
  #  end
  #end

end