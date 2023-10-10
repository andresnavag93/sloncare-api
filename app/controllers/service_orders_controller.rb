class ServiceOrdersController < ApplicationController
  before_action :request_12346!, only: [:index, :show, :close_order_query]
  before_action :request_346!, only: [:create_code, :provider_update_status_sent, :provider_update_status_caused, :provider_create]
  before_action :request_12!, only: [:beneficiary_create, :beneficiary_update_status_verify]
  before_action :request_5!, only: [:index_admin, :destroy]
  before_action :set_service_order, only: [:provider_update_status_sent, :beneficiary_update_status_verify, :close_order_query, :provider_update_status_caused, :show, :destroy]
  
  before_action only: [:show] do 
    verify_correct_path_id(params[:user_id].to_i, [@current_user.id])
    verify_correct_path_id(@current_user.id, [@service_order.beneficiary_id, @service_order.provider_id])   
  end 
  before_action only: [:close_order_query, :beneficiary_update_status_verify, :provider_update_status_sent, :provider_update_status_caused] do 
    verify_correct_path_id(@current_user.id, [@service_order.beneficiary_id, @service_order.provider_id])   
  end 

  before_action only: [:index] do 
    verify_correct_path_id(params[:user_id].to_i, [@current_user.id])   
  end 

  def index_admin 
    index_orders(ServiceOrder, 73)
  end

  def index
    user_access = @current_user
    if user_access.access_id == 69
      orders = user_access.beneficiary_orders.includes(:provider, :specialty)
    elsif [70, 71, 74].include? user_access.access_id
      orders = user_access.provider_orders.includes(:beneficiary, :specialty)
    else
      return render json: {errors: [Errors::translate(73)]}, status: :unprocessable_entity
    end 
    index_orders(orders, user_access.access_id) 
  end

  def show
    access_id = @current_user.access_id
    if @service_order.service_type_id == 84
      render json: @service_order, serializer: ServiceOrderQuerySerializer, scope: {'access_id': access_id}
    elsif @service_order.service_type_id == 85
      render json: @service_order, serializer: ServiceOrderDiagnosticStudySerializer, scope: {'access_id': access_id}
    elsif @service_order.service_type_id == 86
      render json: @service_order, serializer: ServiceOrderOutpatientTreatmentSerializer, scope: {'access_id': access_id}
    elsif @service_order.service_type_id == 87
      render json: @service_order, serializer: ServiceOrderMinorSurgerySerializer, scope: {'access_id': access_id}
    elsif @service_order.service_type_id == 88
      render json: @service_order, serializer: ServiceOrderProviderSerializer, scope: {'access_id': access_id}
    elsif @service_order.service_type_id == 89
      render json: @service_order, serializer: ServiceOrderAdmissionClinicSerializer, scope: {'access_id': access_id}
    end
  end

  def beneficiary_create 
    begin
      valid_date(params[:o_appointment_date], 3)
      @service_type = params[:service_type].to_i
      if [84, 85, 86, 88].include? (@service_type)
        @beneficiary = @current_user
        if @beneficiary.nil? or @beneficiary.access_id != 69
          return render json: {errors: [Errors::translate(74)]}, status: :unprocessable_entity
        elsif !params[:group_wallet_id].nil?
          @group = Group.find_by(wallet_id: params[:group_wallet_id])
          if @group.nil?
            return render json: {errors: [Errors::translate(52)]}, status: :unprocessable_entity
          elsif @group.group_beneficiaries.find_by(beneficiary_id: @beneficiary.id).nil?
            return render json: {errors: [Errors::translate(56)]}, status: :unprocessable_entity
          else
            protocols_id = @group.wallet.protocols.map { |p| p.id }
            if !Checks::wallet_active_protocols?(protocols_id, @service_type)
              return render json: {errors: [Errors::translate(10)]}, status: :unprocessable_entity
            end
          end
        end
        if @service_type == 84 or @service_type == 86
          beneficiary_create_84_or_86
        elsif @service_type == 85
          beneficiary_create_85
        elsif @service_type == 88
          beneficiary_create_88
        end
      else
        render json: {errors: [Errors::translate(60)]}, status: :unprocessable_entity
      end
    rescue ArgumentError => e
      return render json: {errors: [Errors::translate(e.message)]}, status: :unprocessable_entity
    end  
  end

  def provider_update_status_sent
    begin
      if params[:o_appointment_date]
        date = params[:o_appointment_date].to_date
        if date != @service_order.o_appointment_date
          date_server = Time.now.to_date
          limit = (@service_order.created_at.to_date - date_server).to_i
          limit = 0 if limit < 0 
          if date < date_server or date_server + (30 - limit) < date
            return render json: {errors: [Errors::translate(4)]}, status: :unprocessable_entity
          end
        end
      end
    rescue
      return render json: {errors: [Errors::translate(4)]}, status: :unprocessable_entity
    end
    if @service_order.status_id != 90
      render json: {errors: [Errors::translate(66)]}, status: :unprocessable_entity
    else
      if [84, 86].include? @service_order.service_type_id
        @service_order.assign_attributes(update_sent_84_86_params)
        if @service_order.total != @service_order.total_suggested
          item = @service_order.items.first
          item.price_end = @service_order.total
          item.total = @service_order.total
          item.save
          @service_order.status_id = 91
        else
          @service_order.status_id = 92
        end
        @service_order.save
      elsif 85 == @service_order.service_type_id
        @service_order.assign_attributes(update_sent_85_88_params)
        total_suggested = @service_order.total_suggested
        total_suggested_new = 0
        change = false
        for i in params[:items]
          item = @service_order.items.find(i[:id])
          if i[:price_end].to_d != item.total
            item.price_end = i[:price_end].to_d
            item.total = i[:price_end].to_d
            item.save
            total_suggested_new += item.total
            change = true
          else
            total_suggested_new += item.total
          end
        end
        if change
          @service_order.total = total_suggested_new
          @service_order.status_id = 91
        else
          @service_order.status_id = 92
        end
        @service_order.save
      elsif 88 == @service_order.service_type_id
        @service_order.assign_attributes(update_sent_85_88_params)
        @service_order.status_id = 91
        total_suggested_new = 0
        for i in params[:items]
          record = OrderRecord.new({ quantity: 1, price_end: i[:price_end].to_d, total: i[:price_end].to_d, 
            description: i[:description], title: i[:title], record_id: 110, service_order: @service_order})
          record.save 
          total_suggested_new += record.total
        end
        @service_order.total = total_suggested_new
        @service_order.save
      else
        return render json: {errors: [Errors::translate(60)]}, status: :unprocessable_entity
      end
      render json: {success: 2}, status: :ok
    end
  end

  def beneficiary_update_status_verify
    #Verify Status (VERIFICATION)
    if @service_order.status_id != 91
      render json: {errors: [Errors::translate(64)]}, status: :unprocessable_entity
    else
      if @service_order.group_id.nil?
        wallet = @service_order.beneficiary.wallet
      else
        wallet = @service_order.group.wallet
      end
      #Change Status to (APROVE)
      if [84, 86, 85].include? @service_order.service_type_id
        if @service_order.total != @service_order.total_suggested 
          if @service_order.total > @service_order.total_suggested
            amount = @service_order.total - @service_order.total_suggested
            if amount > wallet.available
              return render json: {data: wallet.available, errors: [Errors::translate(58)]}, status: :unprocessable_entity
            end
            wallet.available -= amount
            wallet.deferred += amount
            wallet.save
          elsif @service_order.total < @service_order.total_suggested
            amount = @service_order.total_suggested - @service_order.total
            wallet.available += amount
            wallet.deferred -= amount
            wallet.save
          end    
        end  
      elsif 88 == @service_order.service_type_id
        if @service_order.total > wallet.available
          return render json: {data: wallet.available, errors: [Errors::translate(58)]}, status: :unprocessable_entity
        end
        wallet.available -= @service_order.total
        wallet.deferred += @service_order.total
        wallet.save
      else
        return render json: {errors: [Errors::translate(60)]}, status: :unprocessable_entity     
      end

      @service_order.status_id = 92
      @service_order.save
      render json: {success: 2, data: @service_order }, status: :ok
    end
  end

  def provider_update_status_caused
    #Verify Status (APROVE)
    if @service_order.status_id != 92
     render json: {errors: [Errors::translate(67)]}, status: :unprocessable_entity
    else
      #Finding wallet and locale
      if @service_order.group_id.nil?
        locale = @service_order.beneficiary.user.locale_id
        wallet = @service_order.beneficiary.wallet
        @beneficiary_wallet = false
      else
        locale = @service_order.group.locale_id
        wallet = @service_order.group.wallet
        @beneficiary_wallet = true
      end
      #Verifyint Records od Service Order 87 and 89
      if [87, 89].include? @service_order.service_type_id
        total = 0
        items = []
        for i in params[:items]
          record = OrderRecord.new({ quantity: i[:quantity], price_end: i[:price_end].to_d, 
            total: (i[:price_end].to_d * i[:quantity].to_i), description: i[:description], 
            title: i[:title], unit: i[:unit], record_id: i[:record_id], 
            service_order: @service_order})
          if !record.valid?
            return render json: {errors: [Errors::translate(90)]}, status: :unprocessable_entity 
          end
          items << record 
          total += record.total
        end
        if total > wallet.available
          return render json: {errors: [Errors::translate(77)], data: wallet.available}, status: :unprocessable_entity
        end
        @service_order.total_suggested = total
        @service_order.total = total
      end

      if !params[:base64].nil?
        base64 = ImageAws::extension?(params[:base64], 20, 21)
        if base64.class == Integer
          return render json: {errors: [Errors::translate(base64)]}, status: :unprocessable_entity
        end
      end
      @service_order.assign_attributes(update_caused_params)
      if !@service_order.valid?
        return render json: {errors: Gets::errors(@service_order.errors)}, status: :unprocessable_entity
      end
      #---------------------------------
      #WRITING IN DATABASE
      #If order if 87 or 89 adding records
      if [87, 89].include? @service_order.service_type_id
        for i in items
          i.save
        end
      end
      #change status to Caused
      @service_order.status_id = 93
      @service_order.save
      #Upload Image
      if !params[:base64].nil?
        image = ImageAws::upload(params[:base64], Rails.configuration.route, Rails.configuration.bucket, 
          "service_order_images", "order-"+@service_order.id.to_s, nil, "defaults/image.png")
        item = ImageDoc.new({name: image, service_order: @service_order})
        item.save
      end

      #Calculating service order fee
      slonwallet = Wallet.find(1)
      fee_percentage = TblAttribute.find(124).amount.to_d
      fee = ((@service_order.total.to_d * fee_percentage)/100).round(2)
      total = @service_order.total - fee

      #Exchange moneyfrom beneficiary wallet to provider wallet
      p_wallet = @service_order.provider.wallet
      p_wallet.balance += total
      p_wallet.available += total
      slonwallet.balance += fee
      slonwallet.available += fee
      p_wallet.save
      slonwallet.save

      if ![87, 89].include? @service_order.service_type_id
        wallet.deferred -= @service_order.total
      end
      wallet.balance -= @service_order.total
      wallet.available = (wallet.balance - wallet.deferred)
      wallet.save
      ##Make Transaction
      locale = Gets::locale(locale)
      I18n.locale = locale.to_sym
      msg = I18n.t 'model_mailer.transaction.service_order'
      transac_in = Transac.new({amount: @service_order.total, description: msg + @service_order.id.to_s, outcome: true, income: false, 
        wallet: wallet, pay_wallet: p_wallet, currency_id: 117, transac_type_id: 120, service_order: @service_order}) 

      if @beneficiary_wallet
        msg_2 = I18n.t 'model_mailer.transaction.beneficiary_wallet'
        transac_in.description = transac_in.description + msg_2 + @service_order.beneficiary.wallet_id.to_s
      end
        
      transac_in.save
      msg = I18n.t 'model_mailer.transaction.fee_service_order'
      Transac.new({amount: fee, description: msg + @service_order.id.to_s, outcome: true, income: false, wallet: p_wallet, 
        pay_wallet: slonwallet, currency_id: 117, transac_type_id: 124, transac: transac_in }).save

      render json: {success: 2}, status: :ok
    end
  end

  def close_order_query
    #Verify Status distinct to Caused
    if @service_order.status_id == 93
      render json: {errors: [Errors::translate(66)]}, status: :unprocessable_entity
    elsif @service_order.status_id == 94
      render json: {errors: [Errors::translate(67)]}, status: :unprocessable_entity
    else
      if @service_order.group_id.nil?
        wallet = @service_order.beneficiary.wallet
      else
        wallet = @service_order.group.wallet
      end
      #Status deferred wallet beneficiary and put to his balanca
      if !@service_order.total.nil?
        if @service_order.service_type_id == 88  
          if @service_order.status_id == 92
            wallet.available += @service_order.total
            wallet.deferred -= @service_order.total
            #wallet.balance = wallet.available + wallet.deferred
            wallet.save
          end
        else
          wallet.available += @service_order.total
          wallet.deferred -= @service_order.total
          #wallet.balance = wallet.available + wallet.deferred
          wallet.save
        end
      end
      #Change status to Cancel
      @service_order.status_id = 94
      @service_order.save
      render json: {success: 6}, status: :ok
    end
  end

  def provider_create
    begin
      valid_date(params[:o_appointment_date], 3)
      valid_date(params[:entry_date], 9)
      @service_type = params[:service_type].to_i
      if [84, 85, 86, 87, 88, 89].include? @service_type
        @beneficiary = UserAccess.find_by(wallet_id: params[:beneficiary_wallet_id])
        if @beneficiary.nil? or @beneficiary.access_id != 69
          return render json: {errors: [Errors::translate(74)]}, status: :unprocessable_entity
        elsif @beneficiary.verification_code != params[:verification_code].to_i
          return render json: {errors: [Errors::translate(75)]}, status: :unprocessable_entity
        elsif @beneficiary.code_expires < Time.now
          @beneficiary.verification_code = nil
          @beneficiary.code_expires = nil
          @beneficiary.save
          return render json: {errors: [Errors::translate(76)]}, status: :unprocessable_entity
        elsif !params[:group_wallet_id].nil?
          @group = Group.find_by(wallet_id: params[:group_wallet_id])
          if @group.nil?
            return render json: {errors: [Errors::translate(52)]}, status: :unprocessable_entity
          elsif @group.group_beneficiaries.find_by(beneficiary_id: @beneficiary.id).nil?
            return render json: {errors: [Errors::translate(53)]}, status: :unprocessable_entity
            protocols_id = @group.wallet.protocols.map { |p| p.id }
            if !Checks::wallet_active_protocols?(protocols_id, @service_type)
              return render json: {errors: [Errors::translate(10)]}, status: :unprocessable_entity
            end
          end
        end
        if [84, 86].include? @service_type
          provider_create_84_or_86
        elsif @service_type == 85
          provider_create_85
        elsif [87, 89].include? (@service_type)
          provider_create_87_89
        elsif @service_type == 88
          provider_create_88
        end
      else
        render json: {errors: [Errors::translate(60)]}, status: :unprocessable_entity
      end
    rescue ArgumentError => e
      return render json: {errors: [Errors::translate(e.message)]}, status: :unprocessable_entity
    end       
  end

  def create_code
    user = UserAccess.find(params[:user_id])
    if user.access_id != 69
      render json: {errors: [Errors::translate(74)]}, status: :unprocessable_entity
    else
      i = rand(100000..999999)
      t = Time.now + 300
      user.verification_code = i
      sns = Aws::SNS::Client.new
      cc = user.user.cc_cellphone.to_s
      cellphone = user.user.cellphone
      if cellphone.size == 11 and cellphone[0] == 0.to_s
        cellphone.slice!(0)
      end
      sms =  "Slon Care informa, clave temp: " + i.to_s + " para su solicitud de servicio. " + Time.now.to_s + ". Si no reconoce, ignore este mensaje."
      sns.publish(phone_number: cc + cellphone, message: sms)
      #sns.publish(phone_number: cc + '4149044791', message: 'SlonCode: ' + i.to_s)
      user.code_expires = t
      user.save


      #locale = Gets::locale(params[:locale])
      #ModelMailer.send_verification_code(user.user.email, i.to_s, locale).deliver
      render json: {success: 1}, status: :created
    end
  end

  # def destroy
  #   super(@service_order)
  # end

  private

    def index_orders(service_orders, access_id)
      @offset = params[:init].to_i
      @limit = params[:end].to_i - @offset + 1
      if params[:type].to_i == 1
        service_orders = service_orders.where("status_id = ? OR status_id = ?", 90, 91 ).order("status_id DESC, created_at DESC").offset(@offset).limit(@limit) 
      elsif params[:type].to_i == 2
        service_orders = service_orders.where("status_id = ? ", 92 ).order("created_at DESC").offset(@offset).limit(@limit)
      elsif params[:type].to_i == 3
        service_orders = service_orders.where("status_id = ? ", 93 ).order("created_at DESC").offset(@offset).limit(@limit) 
      elsif params[:type].to_i == 4
        service_orders = service_orders.where("status_id = ? ", 94 ).order("created_at DESC").offset(@offset).limit(@limit)
      else 
        service_orders = service_orders.offset(@offset).limit(@limit) 
      end
      if access_id == 69
        render json: service_orders.includes(:provider, :specialty), scope: {'access_id': access_id}
      elsif [70, 71, 74].include? access_id
        render json: service_orders.includes(:beneficiary), scope: {'access_id': access_id}
      else 
        render json: service_orders.includes(:beneficiary, :provider, :specialty), scope: {'access_id': access_id}
      end
    end

    def beneficiary_create_84_or_86
      get_provider_and_valid_order([70], 63, create_params)
      errors = @errors
      begin
        item = params[:items][0] 
        t = Tabulator.find(item[:tabulator_id])
        @item = Item.new({ quantity: 1, price_init: t.suggested_price, price_end: t.suggested_price, 
          total: t.suggested_price,  tabulator_id: t.id, service_order: @service_order})
        errors += Gets::errors(@item.errors) if !@item.valid?
        if (t.specialty_id != @service_order.specialty_id) or (t.subspecialty_id != @service_order.subspecialty_id)
          errors << Errors::translate(61)
        end
        total_suggested = t.suggested_price
      rescue
        errors << Errors::translate(59)
        total_suggested = nil
      end
      errors = choosing_wallet_and_verify_total_suggested(total_suggested, errors)
      if !errors.empty?
        render json: {errors: errors}, status: :unprocessable_entity
      else
        @service_order.total_suggested = total_suggested
        @service_order.total = total_suggested
        @service_order.group_id = @group.id  if !@group.nil?
        @service_order.save
        @item.save
        @wallet.available -= total_suggested
        @wallet.deferred += total_suggested
        @wallet.save
        send_email_notficacion
      end
    end

    def beneficiary_create_85 
      @group.nil? ? (@wallet = @beneficiary.wallet) : (@wallet = @group.wallet)
      providers = get_providers_tabulators(params[:items], @wallet, params[:specialty_id])
      errors = []
      errors << Errors::translate(providers) if providers.class == Integer
      if !errors.empty?
        render json: {errors: errors}, status: :unprocessable_entity
      elsif providers.empty? 
        render json: {errors: [Errors::translate(70)]}, status: :unprocessable_entity  
      else
        total_suggested = 0
        for k,v in providers
          v[:total_suggested]
          service_order = ServiceOrder.new(create_params)
          service_order.assign_attributes(service_type_id: @service_type, status_id: 90, currency_id: 117, provider_id: k, 
            beneficiary: @beneficiary, total_suggested: v[:total_suggested], total: v[:total_suggested])
          service_order.group_id = @group.id  if !@group.nil?
          service_order.save
          v[:items].each do |i|
            i.service_order = service_order
            i.save
          end
          total_suggested += v[:total_suggested]
        end
        @wallet.available -= total_suggested
        @wallet.deferred += total_suggested
        @wallet.save
        send_email_notficacion
      end
    end

    def beneficiary_create_88
      @providers = Checks::multy_exists?(:providers, 68, UserAccess, 69, params)
      errors = []
      errors << Errors::translate(@providers) if @providers.class == Integer
      if !errors.empty?
        render json: {errors: errors}, status: :unprocessable_entity
      elsif @providers.empty? 
        render json: {errors: [Errors::translate(70)]}, status: :unprocessable_entity  
      else 
        for provider in @providers
          service_order = ServiceOrder.new(create_params)
          service_order.assign_attributes(service_type_id: @service_type, status_id: 90, currency_id: 117, provider_id: provider.id, beneficiary_id: @beneficiary.id, total_suggested: 0, total: 0)
          service_order.group_id = @group.id  if !@group.nil?
          service_order.save
        end
        send_email_notficacion
      end
    end

    def get_providers_tabulators(items, wallet, specialty_id)
      begin
        providers = {}
        total_suggested = 0
        for item in items
          p_id = UserAccess.find(item[:provider_id])
          t = Tabulator.find(item[:tabulator_id])
          if (t.specialty_id != specialty_id)
            return 86
          end
          item = Item.new({ quantity: 1, price_init: t.suggested_price, price_end: t.suggested_price, total: t.suggested_price,  tabulator: t})
          if providers[p_id.id]
            providers[p_id.id][:total_suggested] += t.suggested_price
            providers[p_id.id][:items] << item
          else
            providers[p_id.id] = {}
            providers[p_id.id][:total_suggested] = t.suggested_price
            providers[p_id.id][:items] = [item]
          end 
          total_suggested += t.suggested_price
        end
        if total_suggested > wallet.available
          return 58
        else
          return providers
        end
      rescue
        return 71
      end
    end

    def provider_create_87_89
      get_provider_and_valid_order([70, 71], 63)
      errors = @errors
      if !errors.empty?
        render json: {errors: errors}, status: :unprocessable_entity
      else
        @service_order.total_suggested = 0
        @service_order.total = 0
        if !@group.nil?
          @service_order.group_id = @group.id
        end
        @service_order.save
        verification_code_to_null_and_send_email
      end
    end

    def provider_create_84_or_86
      get_provider_and_valid_order([70], 63)
      errors = @errors
      begin
        item = params[:items][0] 
        t = Tabulator.find(item[:tabulator_id])
        i = Item.new({ quantity: 1, price_init: item[:price_end].to_d, price_end: item[:price_end].to_d, 
          total: item[:price_end].to_d, tabulator_id: t.id, service_order: @service_order})
        errors += Gets::errors(i.errors) if !i.valid?
        @items = [i]
        if (t.specialty_id != @service_order.specialty_id) or (t.subspecialty_id != @service_order.subspecialty_id)
          errors << Errors::translate(61)
        end
        total_suggested = i.price_end
      rescue
        errors << Errors::translate(59)
        total_suggested = nil
      end
      errors = choosing_wallet_and_verify_total_suggested(total_suggested, errors)
      if !errors.empty?
        render json: {errors: errors}, status: :unprocessable_entity
      else
        save_service_order_items_and_update_wallet(total_suggested)
        verification_code_to_null_and_send_email
      end
    end

    def provider_create_85
      get_provider_and_valid_order([71], 63)
      errors = @errors
      begin
        total_suggested = 0
        @items = []
        for item in params[:items]
          t = Tabulator.find(item[:tabulator_id])
          i = Item.new({ quantity: 1, price_init: item[:price_end].to_d, price_end: item[:price_end].to_d, 
            total: item[:price_end].to_d, tabulator_id: t.id, service_order: @service_order})
          errors += Gets::errors(i.errors) if !i.valid?
          @items << i
          if (t.specialty_id != @service_order.specialty_id)
            errors << Errors::translate(86)
            total_suggested = nil
            break
          end
          total_suggested += i.price_end
        end
      rescue
        errors << Errors::translate(59)
        total_suggested = nil
      end
      errors = choosing_wallet_and_verify_total_suggested(total_suggested, errors)
      if !errors.empty?
        render json: {errors: errors}, status: :unprocessable_entity
      else
        save_service_order_items_and_update_wallet(total_suggested)
        verification_code_to_null_and_send_email
      end
    end

    def provider_create_88
      get_provider_and_valid_order([70, 71, 74], 63)
      errors = @errors
      begin
        total_suggested = 0
        @items = []
        for i in params[:items]
          record = OrderRecord.new({ quantity: 1, price_end: i[:price_end].to_d, total: i[:price_end].to_d, 
            description: i[:description], title: i[:title], record_id: 110, service_order: @service_order})
          errors += Gets::errors(record.errors) if !record.valid?
          total_suggested += record.total
        end
      rescue
        errors << Errors::translate(59)
        total_suggested = nil
      end
      errors = choosing_wallet_and_verify_total_suggested(total_suggested, errors)
      if !errors.empty?
        render json: {errors: errors}, status: :unprocessable_entity
      else
        save_service_order_items_and_update_wallet(total_suggested)
        verification_code_to_null_and_send_email
      end
    end

    def get_provider_and_valid_order(list, code, custom_params=nil)
      if !list.include? @current_user.access_id 
        @provider = UserAccess.find_by(id: params[:provider_id])
        status_id = 90
      else
        @provider = @current_user
        status_id = 92
      end

      if @provider.nil? or !list.include? @provider.access_id
        raise ArgumentError.new(code) 
      end
      custom_params.nil? ? ( aux = create_provider_params) : (aux = custom_params)
      @service_order = Checks::valid?(ServiceOrder, aux, [:service_type_id, @service_type], 
        [:currency_id, 117], [:status_id, status_id], [:beneficiary, @beneficiary], [:provider, @provider])
      @errors = []
      @errors = @service_order if @service_order.class == Array
    end

    def choosing_wallet_and_verify_total_suggested(total_suggested, errors)
      #Choosing group id wallet
      @group.nil? ? (@wallet = @beneficiary.wallet) : (@wallet = @group.wallet)
      #Verify if wallet beneficiary has amount
      if !total_suggested.nil? 
        #With permisologies @current_user would be @beneficiary
        if total_suggested > @wallet.available
          errors << Errors::translate(58)
        elsif total_suggested == 0.0
          errors << Errors::translate(65)
        end
      end
      return errors
    end

    def save_service_order_items_and_update_wallet(total_suggested)
      #Set total to suggested price and total
      @service_order.total_suggested = total_suggested
      @service_order.total = total_suggested
      #Adding group_id to order if is not null
      @service_order.group_id = @group.id if !@group.nil?
      @service_order.save
      #Create order and items with status
      for item in @items
        item.save
      end
      #Decrease wallet to
      @wallet.available -= total_suggested
      @wallet.deferred += total_suggested
      @wallet.save
    end

    def verification_code_to_null_and_send_email
      @beneficiary.verification_code = nil
      @beneficiary.code_expires = nil
      @beneficiary.save
      send_email_notficacion
    end

    def send_email_notficacion
      #locale = Gets::locale(params[:locale])
      #Thread.new do
      #  ModelMailer.send_service_request_notification(@beneficiary.user.email, locale).deliver
      #  ActiveRecord::Base.connection.close
      #end
      render json: {success: 1 }, status: :created
    end

    def valid_date(date_in, code)
      if date_in
        date = date_in.to_date
        date_server = Time.now.to_date
        if date < date_server or date_server + 30 < date
          raise ArgumentError.new(code) 
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_service_order
      @service_order = ServiceOrder.find(params[:id])
    end

    def create_params
      params.require(:service_order).permit(
        :specialty_id, :subspecialty_id, :priority_id, :country_id,
        :state_id, :city_id, :beneficiary_id, :o_appointment_date,
        :provider_id, :reason_for_admission, :symptom, :b_observations, :group_wallet_id, :currency_id)
    end

    def update_sent_84_86_params
      params.require(:service_order).permit(:total, :p_observations, :o_appointment_date)
    end

    def update_sent_85_88_params
      params.require(:service_order).permit(:p_observations, :o_appointment_date)
    end

    def update_caused_params
      params.require(:service_order).permit(
        :recipe, :indications, :recipe_comments, :indications_comments, 
        :medical_report, :diagnosis, :evolutionary_report, :egress_report, :egress_date, :high_id)
    end

    def create_provider_87_89_params
      params.require(:service_order).permit(
        :specialty_id, :subspecialty_id, :priority_id, :country_id,
        :state_id, :city_id, :o_appointment_date, :beneficiary_wallet_id,
        :provider_id, :reason_for_admission, :symptom, :p_observations, :income_id, 
        :livelihood, :assigned_area_id, :room_number, :entry_date)
    end

    def create_provider_params
      params.require(:service_order).permit(
        :specialty_id, :subspecialty_id, :priority_id, :country_id,
        :state_id, :city_id, :o_appointment_date, :beneficiary_wallet_id,
        :provider_id, :reason_for_admission, :symptom, :p_observations, :b_observations, :income_id, 
        :livelihood, :assigned_area_id, :room_number, :entry_date)
    end

end
