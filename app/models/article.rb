class Article < ApplicationRecord
  belongs_to :locale, :class_name => 'TblAttribute'

end
