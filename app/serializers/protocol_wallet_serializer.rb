class ProtocolWalletSerializer < ActiveModel::Serializer
  attributes :id, :percentage, :protocol_id, :wallet_id
  
end
