class UserAccessSerializer < ActiveModel::Serializer
  attributes :id, :is_active, :visibility, :access_id, :user_id, :wallet_id
end
