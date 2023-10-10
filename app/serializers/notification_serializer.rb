class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :access_id
end
