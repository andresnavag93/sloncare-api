class UserSerializer < ActiveModel::Serializer
  attributes :id, :access_id, :name, :email, :is_active, :wallet_id

  def name
    object.user.name
  end

  def email
    object.user.email
  end
end
