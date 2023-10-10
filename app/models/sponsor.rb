class Sponsor < ApplicationRecord
  belongs_to :country, :class_name => 'Location', optional: true
  validates :email, 
  	uniqueness: { message: :uniqueness } , 
  	email_format: {message: :email_format },
  	presence: { message: :presence }
end
