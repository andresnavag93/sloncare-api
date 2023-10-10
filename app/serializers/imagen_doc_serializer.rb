class ImageDocSerializer < ActiveModel::Serializer
  attributes :id, :name, :image, :service_order_id, :image_type_id
end
