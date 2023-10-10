class ImageDoc < ApplicationRecord
  belongs_to :service_order
  belongs_to :image_type, :class_name => 'TblAttribute', optional: true
end
