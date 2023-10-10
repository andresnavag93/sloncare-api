class ProviderSerializer < ActiveModel::Serializer
  attributes :name, :lastname, :businessname, :email, :localphone, :cellphone,
  :cc_localphone, :cc_cellphone

end