class TblAttributeSerializer < ActiveModel::Serializer
  attributes :id, :name, :value, :amount, :tbl_attribute_id
  
  def name
    if !scope[:locale].nil? and scope[:locale].to_i == 29
      object.name_en
    else
      object.name
    end
  end

  def value
    if !scope[:locale].nil? and scope[:locale].to_i == 29
      object.value_en
    else
      object.value
    end
  end

  #def serializable_hash(
  #  adapter_options = nil, 
  #  options = {}, 
  #  adapter_instance = self.class.serialization_adapter_instance)
  #  hash = super
  #  hash.each { |key, value| hash.delete(key) if value.nil? }
  #  hash
  #end
end
