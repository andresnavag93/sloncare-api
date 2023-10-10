class ProtocolWallet < ApplicationRecord
  belongs_to :wallet
  belongs_to :protocol, :class_name => 'TblAttribute'
end
