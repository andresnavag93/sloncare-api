class SpecialtySerializer < ActiveModel::Serializer
  attributes :id, :name, :base, :specialty_id, :_id, :_name

  def name
    if !scope[:locale].nil? and scope[:locale].to_i == 29
      object.name_en
    else
      object.name
    end
  end
end
