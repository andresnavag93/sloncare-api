class Suggestion < ApplicationRecord
  belongs_to :user_access, optional: true
  belongs_to :suggestion_type, :class_name => 'TblAttribute'
end
