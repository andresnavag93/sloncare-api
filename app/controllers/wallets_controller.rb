class WalletsController < ApplicationController
  before_action :request_12346!, only: [:recharge_wallets, :nested_pagination, :withdraw_money]
  before_action :request_8!, only: [:pending_transacs, :checked_transacs, :check_transacs]
  before_action :request_346!, only: [:wallet_money_available]
  before_action only: [:recharge_wallets, :nested_pagination, :withdraw_money] do  
    if @current_user.wallet_id.nil? 
      verify_correct_path_id(params[:id].to_i, [@current_user.group_admins.first.group.wallet_id]) 
    else
      verify_correct_path_id(params[:id].to_i, [@current_user.wallet.id]) 
    end
  end
  before_action :set_wallet, only: [:recharge_wallets, :nested_pagination, :withdraw_money]


  def nested_pagination
    @offset = params[:init].to_i
    @limit = params[:end].to_i - @offset + 1
    @objs = Transac.where("wallet_id = ? OR pay_wallet_id = ?", @wallet.id, @wallet.id).order("created_at DESC").offset(@offset).limit(@limit)
    render json: @objs, scope: {'wallet': @wallet.id}
  end

  def recharge_wallets
    code = Checks::valid_code?(Sloncode, "code", params[:sloncard_code], "transac_id", 31, 32)
    errors = []
    errors << code if code.class == Integer
    if !errors.empty?
      return render json: {errors: errors}, status: :unprocessable_entity
    end
    locale = Gets::locale(params[:locale])
    @wallet = Posts::change_code(code, @wallet, locale)
    render json: {success: 1}, status: :created
  end

  def withdraw_money
      #Calculating service order fee
      if params[:amount].nil? or params[:amount].to_d <= 0
        return render json: {errors: [Errors::translate(85)]}, status: :unprocessable_entity
      elsif params[:amount].to_d > @wallet.available
        return render json: {errors: [Errors::translate(77)]}, status: :unprocessable_entity
      end
      slonwallet = Wallet.find(1)
      fee_percentage = TblAttribute.find(127).amount.to_d
      amount = params[:amount].to_d
      fee = ((amount * fee_percentage)/100).round(2)
      @wallet.available -= amount
      @wallet.deferred += amount
      @wallet.balance = @wallet.available + @wallet.deferred
      @wallet.save

      ##Make Transaction
      locale = Gets::locale(params[:locale])
      I18n.locale = locale.to_sym
      msg = I18n.t 'model_mailer.transaction.withdraw'
      transac_in = Transac.new({
        amount: amount, 
        description: msg, 
        wallet: @wallet, 
        currency_id: 117, 
        transac_type_id: 122, 
        checked: false,
        zelle: params[:zelle],
        bank_name: params[:bank_name],
        account: params[:account],
        comments: params[:comments],
        swift: params[:swift],
        aba: params[:aba],
        paypal: params[:paypal],
        stripe: params[:stripe],
        country_name: params[:country_name],
        state_name: params[:state_name],
        city_name: params[:city_name],
        zipcode: params[:zipcode],
        holder_name: params[:holder_name],
        holder_email: params[:holder_email],
        address: params[:address]
        }
      )
      transac_in.save  
      msg = I18n.t 'model_mailer.transaction.fee_withdraw'
      Transac.new({amount: fee, description: msg, wallet: @wallet, pay_wallet: slonwallet, currency_id: 117, transac_type_id: 127, transac: transac_in, checked: false}).save

      render json: {success: 2}, status: :ok
  end

  def pending_transacs
    @offset = params[:init].to_i
    @limit = params[:end].to_i - @offset + 1
    if ![69, 70, 71, 74].include? params[:type].to_i
      return render json: {errors: [Errors::translate(87)]}, status: :unprocessable_entity
    end
    wallets = Wallet.joins(:user_access).where("access_id = ?", params[:type].to_i).map {|w| w.id }
    @objs = Transac.where("wallet_id in (?) and transac_id is not NULL and not checked and transac_type_id = 127", wallets).order("created_at DESC").offset(@offset).limit(@limit)
    render json: @objs, each_serializer: PendingTransacSerializer
  end

  def checked_transacs
    @offset = params[:init].to_i
    @limit = params[:end].to_i - @offset + 1
    if ![69, 70, 71, 74].include? params[:type].to_i
      return render json: {errors: [Errors::translate(87)]}, status: :unprocessable_entity
    end
    wallets = Wallet.joins(:user_access).where("access_id = ?", params[:type].to_i).map {|w| w.id }
    @objs = Transac.where("wallet_id in (?) and transac_id is not NULL and checked and transac_type_id = 127", wallets).order("created_at DESC").offset(@offset).limit(@limit)
    render json: @objs, each_serializer: PendingTransacSerializer
  end

  def check_transacs
    transac_fee = Transac.find(params[:id])
    if !transac_fee.checked
      transac_fee.checked = true
      transac_fee.save
    end
    transac_amount = transac_fee.transac
    if !transac_amount.checked
      transac_amount.checked = true
      transac_amount.save
    end

    slonwallet = transac_fee.pay_wallet
    slonwallet.balance += transac_fee.amount
    slonwallet.available += transac_fee.amount
    slonwallet.save

    wallet = transac_fee.wallet
    wallet.deferred -= transac_amount.amount 
    wallet.balance -= transac_amount.amount 
    wallet.available = (wallet.balance - wallet.deferred)
    wallet.save

    render json: {success: 2}, status: :ok
  end

  def wallet_money_available
    user = UserAccess.find_by(wallet_id: params[:id].to_i, access_id: 69)
    if user.nil?
      group = Group.find_by(wallet_id: params[:id].to_i)
      if !group.nil?
        return render json: {available: group.wallet.available}, status: :ok
      end
    else
      return render json: {available: user.wallet.available}, status: :ok
    end

    return render json: {errors: [Errors::translate(84)]}, status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallet
      if @current_user.wallet_id.nil? 
        @wallet = @current_user.group_admins.first.group.wallet
      else
        @wallet = @current_user.wallet
        #@wallet = Wallet.find(params[:id])
      end
    end

    # Only allow a trusted parameter "white list" through.
    def wallet_params
      params.require(:wallet).permit(:balance, :deferred, :available)#, :code, :code_expires)
    end
end
