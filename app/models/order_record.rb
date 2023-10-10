class OrderRecord < ApplicationRecord
  belongs_to :service_order
  belongs_to :record, :class_name => 'TblAttribute'
  belongs_to :tabulator, optional: true
end
