class OrderRecordsController < ApplicationController
  before_action :request_346!, only: [:create, :update, :destroy]
  before_action :set_order_record, only: [:update, :destroy]
  before_action :set_service_order, only: [:create, :update, :destroy]

  before_action only: [:create, :update, :destroy] do 
    verify_correct_path_id(@current_user.id, [@service_order.provider_id])   
  end 

  def create
    #Validate that total
    @obj = OrderRecord.new(order_record_params)
    if !@obj.valid?
      render json: {errors: Gets::errors(@obj.errors)}, status: :unprocessable_entity
    else
      #Search Order
      @obj.total = @obj.quantity * @obj.price_end
      #@service_order = ServiceOrder.find_by(id: params[:id])
      if @service_order.nil? or ![87, 89].include? @service_order.service_type_id
        return render json: {errors: [Errors::translate(60)]}, status: :unprocessable_entity
      end
      #Search beneficiary wallet id
      #Validate that beneficiary has wallet amount with new wallet

      @wallet = @service_order.beneficiary.wallet
      #if @wallet.balance < @obj.total
      if @wallet.available < @obj.total
         return render json: {errors: [Errors::translate(77)], data: @wallet.available}, status: :unprocessable_entity
      end
      @service_order.total += @obj.total
      @service_order.save
      #Decrease balance wallet to
      #@wallet.balance -= @obj.total
      @wallet.available -= @obj.total
      @wallet.deferred += @obj.total
      @wallet.save
      #Save new record
      @obj.service_order = @service_order
      @obj.save
      render json: {data: @obj, success: 1}, status: :created
    end
  end

  def update
    #@service_order = ServiceOrder.find_by(id: params[:id])
    if @service_order.nil? or ![87, 89].include? @service_order.service_type_id
      return render json: {errors: [Errors::translate(60)]}, status: :unprocessable_entity
    elsif @obj.service_order != @service_order
      return render json: {errors: [Errors::translate(91)]}, status: :unprocessable_entity
    end
    @obj.attributes = order_record_params
    if @obj.valid?
      new_total = @obj.quantity * @obj.price_end
      if new_total != @obj.total
        @wallet = @service_order.beneficiary.wallet
        if new_total > @obj.total
          amount = new_total - @obj.total
          #if amount > @wallet.balance 
          if amount > @wallet.available
             return render json: {errors: [Errors::translate(77)], data: @wallet.available}, status: :unprocessable_entity
          end
          @service_order.total += amount
          @service_order.save
          #@wallet.balance -= amount
          @wallet.available -= amount
          @wallet.deferred += amount
          @wallet.save
        elsif new_total < @obj.total
          amount = @obj.total - new_total
          @service_order.total -= amount
          @service_order.save
          #@wallet.balance += amount
          @wallet.available += amount
          @wallet.deferred -= amount
          @wallet.save
        end
        @obj.total = new_total
      end
      @obj.save
      render json: {data: @obj, success: 2}, status: :ok
    else
      render json: {errors: Gets::errors(@obj.errors)}, status: :unprocessable_entity
    end
  end

  def destroy
    #@service_order = ServiceOrder.find_by(id: params[:id])
    if @service_order.nil? or ![87, 89].include? @service_order.service_type_id
      return render json: {errors: [Errors::translate(60)]}, status: :unprocessable_entity
    elsif @obj.service_order != @service_order
      return render json: {errors: [Errors::translate(91)]}, status: :unprocessable_entity
    end
    #Search beneficiary wallet id
    @wallet = @service_order.beneficiary.wallet
    @service_order.total -= @obj.total
    @service_order.save
    #Increase crease balance wallet to
    #@wallet.balance += @obj.total
    @wallet.available += @obj.total
    @wallet.deferred -= @obj.total
    @wallet.save
    #Delete new record
    @obj.destroy
    render json: {data: {}, success: 3}, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_record
      @obj = OrderRecord.find(params[:order_record_id])
    end

    def set_service_order
      @service_order = ServiceOrder.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_record_params
      params.require(:order_record).permit(:service_order_id, :record_id, :tabulator_id, :price_end, :title, :description, :record_name, :quantity, :unit)
    end
end
