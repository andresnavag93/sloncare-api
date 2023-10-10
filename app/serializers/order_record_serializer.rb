class OrderRecordSerializer < ActiveModel::Serializer
  attributes :id, :price_end, :title, :description, :record_name, :quantity, 
	:total,  :unit,  :service_order_id,  :record_id
end
