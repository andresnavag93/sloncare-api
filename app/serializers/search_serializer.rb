class SearchSerializer < ActiveModel::Serializer
  has_many :yes, each_serializer: TabulatorSerializer
  has_many :no, each_serializer: TabulatorSerializer
end