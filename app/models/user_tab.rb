class UserTab < ApplicationRecord
  belongs_to :user_specialty
  belongs_to :tabulator
  validates :user_specialty_id, uniqueness: { scope: :tabulator_id, message: "Servicio duplicado" }
end
