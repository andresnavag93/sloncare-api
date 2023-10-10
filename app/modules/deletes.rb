module Deletes
  class << self
    
    def creditcard(obj, code)
      if obj.customer_id
        customer = CustomStripe::destroy_creditcard(obj.customer_id, code)
        return code if customer == code
        obj.customer_id = nil
        obj.save
      else
        return code
      end
      return true
    end
  end
end