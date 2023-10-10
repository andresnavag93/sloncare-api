class LocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :value, :cc, :location_id

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

end
