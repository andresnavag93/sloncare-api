module CustomPaypal
  class << self
    
    def verify(token, total, code, code2)
      begin
        charge = PayPal::SDK::REST::Payment.find(token)
        charge.state != "approved" ? (return code) : (amount = 0.0)
        charge.transactions.each { |t| amount += t.amount.total.to_d }
        if amount != total.to_d 
          return code2 
        else 
          fee = charge.transactions[0].related_resources[0].sale.transaction_fee.value
          return [token, fee]
        end
      rescue Exception => e
        return code
      end
    end
  end
end