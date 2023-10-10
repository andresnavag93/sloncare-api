class Notification < ApplicationRecord
  belongs_to :access, :class_name => 'TblAttribute'
end
