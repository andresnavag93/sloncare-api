class Search
	include ActiveModel::Model
	include ActiveModel::Serialization
 	attr_accessor :yes, :no
  	
  	def initialize(yes, no)
   		@yes = yes
    	@no = no
  end
end