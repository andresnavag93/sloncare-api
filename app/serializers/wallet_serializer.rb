class WalletSerializer < ActiveModel::Serializer
  attributes :id, :balance, :deferred, :available
end
