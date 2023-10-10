class SponsorSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :phone, :cc_phone, :document, :country_id, :country_code
  
end
