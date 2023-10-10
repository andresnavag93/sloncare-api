class AdministratorSerializer < ActiveModel::Serializer
  attributes :id, :access_id, :name, :email

  def name
  	object.user.name
  end

  def email
  	object.user.email
  end
  
end