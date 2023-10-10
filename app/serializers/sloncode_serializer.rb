class SloncodeSerializer < ActiveModel::Serializer
  attributes :id, :p_reference, :code, :price, 
  	:encrypt_id, :payment_id, :transac_id, :fee

end
