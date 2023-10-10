class Sloncode < ApplicationRecord
  belongs_to :encrypt, :class_name => 'TblAttribute', optional: true
  belongs_to :payment, :class_name => 'TblAttribute'
  belongs_to :transac, optional: true
  belongs_to :currency, :class_name => 'TblAttribute', optional: true
  validates :code, uniqueness: true, presence: true
  validates :price, presence: true
end
