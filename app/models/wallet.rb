class Wallet < ApplicationRecord
  has_many :transacs, dependent: :destroy
  has_many :protocol_wallets, dependent: :destroy
  has_many :protocols, through: :protocol_wallets

  has_one :user_access
end
