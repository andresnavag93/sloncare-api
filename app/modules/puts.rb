module Puts
  class << self
    
    def creditcard(token, obj, email, code)
      if token != nil
        if !obj.customer_id
          customer = Posts::membership(token, obj, email, code)
          return code if customer == code
        else
          card = CustomStripe::update_creditcard(obj.customer_id, token, code)
          return code if card == code
        end
      else
        return code
      end
      return true
    end
  end
end