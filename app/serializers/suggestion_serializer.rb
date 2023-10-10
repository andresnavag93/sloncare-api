class SuggestionSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :description, :suggestion_type_id
end
