class ItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :price_init, :price_end, 
  	:checked, :total, :tabulator_id, :name, :description

  def name
  	object.tabulator.name
  end

  def description
  	object.tabulator.description
  end
  
end
