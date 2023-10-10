class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :picture, :locale_id
  
end
