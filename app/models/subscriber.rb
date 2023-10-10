class Subscriber < ApplicationRecord
	validates :email, uniqueness: { message: :uniqueness }, email_format: { message: :email_format }, presence: { message: :presence }
end
