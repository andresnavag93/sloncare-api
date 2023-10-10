class Item < ApplicationRecord
  belongs_to :tabulator
  belongs_to :service_order
end
