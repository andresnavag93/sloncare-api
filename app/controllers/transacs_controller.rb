class TransacsController < ApplicationController

  def buy_sloncard_code
    sponsor = Gets::one(Sponsor, "email", params[:sponsor][:email], sponsor_params)
    if sponsor.class == Array
      return render json: {errors: sponsor}, status: :unprocessable_entity
    end
    charge = make_payment(params[:payment_id], params[:token], params[:amount])
    if charge.class == Integer
      return render json: {errors: [Errors::translate(charge)]}, status: :unprocessable_entity
    end
    while true
      random_code = SecureRandom.hex(6).downcase
      code = Sloncode.new({p_reference: charge[0], fee: charge[1], code: random_code, 
        price: params[:amount], payment_id: params[:payment_id], currency_id: 117})
      if code.valid?
        code.save
        break
      end
    end
    locale = Gets::locale(params[:locale])
    #Thread.new do
     ModelMailer.send_sloncard(sponsor, code, locale).deliver
    #   ActiveRecord::Base.connection.close
    #end
    render json: {success: 1}, status: :created
  end

  def make_payment(payment_id, token, amount)
    if payment_id.to_i == 34
      return CustomStripe::charge(token, (amount.to_i)*100,'usd', 5)
    elsif payment_id.to_i == 35
      if Sloncode.find_by(p_reference: params[:token]).nil?
        return CustomPaypal::verify(token, amount, 7, 8)
      else
        return 88
      end
    else 
      return 6
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transac
      @transac = Transac.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transac_params
      params.require(:transac).permit(:income, :outcome, :amount, :description, :wallet_id, :pay_wallet_id, :service_order_id, :transac_type_id, :currency_id)
    end

    def sponsor_params
      params.require(:sponsor).permit(:email, :name, :phone, :cc_phone, :document, :country_id, :country_code)
    end
end
