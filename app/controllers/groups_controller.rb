class GroupsController < ApplicationController
  before_action :request_1!, only: [:show, :update, :get_creditcard, :put_creditcard, :delete_creditcard, :beneficiaries]
  before_action only: [:show, :update, :get_creditcard, :put_creditcard, :delete_creditcard, :beneficiaries] do 
    verify_correct_path_id(params[:id].to_i, [@current_user.group_admins.first.group_id])   
  end 
  before_action :set_group, only: [:show, :update, :get_creditcard, :put_creditcard, :delete_creditcard, :beneficiaries ]


  def show
    super(@group, params[:locale])
  end

  def create
    if group_is_valid?
      #Create Admin
      Gets::md5_encrypt(@admin, :password, :aq_1, :aq_2)
      @admin.save
      @wallet.save
      @group.save
      #Create User Access for this admin
      user_access = UserAccess.new({user: @admin, access_id: 72, is_active: true})
      user_access.save
      #Adding admin to group
      group_admin = GroupAdmin.new({admin: user_access, group: @group})
      group_admin.save

      if @admin2
        Gets::md5_encrypt(@admin2, :password, :aq_1, :aq_2)
        @admin2.save
        user_access = UserAccess.new({user: @admin2, access_id: 72, is_active: true})
        user_access.save
        #Adding admin to group
        group_admin = GroupAdmin.new({admin: user_access, group: @group})
        group_admin.save
      end

      #Adding Procotols
      for protocol in @protocols
        ProtocolWallet.new({wallet: @wallet, protocol: protocol, percentage: 100}).save
      end
      locale = Gets::locale(params[:locale])
      #Charge wallet and create Transactions (Normal and Fee)
      @wallet = Posts::change_code(@code, @wallet, locale) if !@code.nil?

      #Send Email
      #Thread.new do
        ModelMailer.send_welcome_group(
          @group, @admin, params[:admin][:password], @wallet, @group.plan, 
          @group.saving_level, locale).deliver      
      #  ActiveRecord::Base.connection.close
      #end
      render json: {success: 1}, status: :created
    end
  end

  def group_is_valid?
    #Validate sloncard code
    if (params[:sloncard_code] != nil) and (params[:sloncard_code] != "")
      @code = Checks::valid_code?(Sloncode, "code", params[:sloncard_code], "transac_id", 31, 32)
    else
      @code = nil
    end

    @wallet = Wallet.new
    #Validate admin
    @admin = Checks::valid?(UserAdminOne, admin_params, [:locale_id, 28])
    #Validate Protocols
    @protocols = Checks::multy_exists?(:protocols, 39, TblAttribute, 49, params)
    #Errors of endpoints
    errors = []
    errors = @admin if @admin.class == Array 
    #Validate second admin if exists 
    if params[:admin2] and params[:admin2][:email]
      @admin2 = Checks::valid?(UserAdminTwo, admin2_params, [:locale_id, 28]) 
      if @admin2.class == Array
        errors += @admin2 
      else 
        errors << Errors::translate(57) if @admin2.email == params[:admin][:email]
      end
      a_count = 2
    else
      a_count = 1
    end
    
    #Validate Group Fields
    params[:type].to_i == 31 ? (plan_id = 31) : (plan_id = 32)
    @group = Checks::valid?(Group, group_params, [:plan_id, plan_id], [:wallet, @wallet], [:b_count, 0], [:a_count, a_count])
    errors += @group if @group.class == Array
    errors << Errors::translate(@protocols) if @protocols.class == Integer
    errors << Errors::translate(@code) if @code.class == Integer
    if !errors.empty?
      render json: {errors: errors}, status: :unprocessable_entity
      return false
    else
      return true
    end
  end

  def get_creditcard
    render json: Gets::creditcard(@group)
  end

  def put_creditcard
    var = Puts::creditcard(params[:stripeToken], @group, @group.c_email, 50)
    if var == 50
      render json: {success: 2}, status: :ok
    else
      render json: {errors: [Errors::translate(50)]}, status: :ok
    end
  end

  def delete_creditcard
    var = Deletes::creditcard(@group, 51)
    if var == 51
      render json: {success: 3}, status: :ok
    else
      render json: {errors: [Errors::translate(51)]}, status: :ok
    end
  end

  def beneficiaries
    @group = Gets::one(Group, "id", params[:id], nil, false, 52)
    if @group.class == Array
      render json: {errors: [Errors::translate(52)]}, status: :unprocessable_entity
    else
      for user in @group.group_beneficiaries
        user.name = user.beneficiary.user.name
        user.lastname = user.beneficiary.user.lastname
        user.email = user.beneficiary.user.email
        user.document = user.beneficiary.user.document
        user.wallet_id = user.beneficiary.wallet_id
      end
      render json: @group.group_beneficiaries
    end
  end

  def update
    if @group.update(group_update_params)
      #update_wallet_protocols(@group.wallet)
      render json: {data: @group, success: 2}, status: :ok
    else
      render json: {errors: Gets::errors(@group.errors)}, status: :unprocessable_entity
    end    
  end

  # def update_wallet_protocols(wallet)
  #   aux = false
  #   objs = wallet.protocol_wallets
  #   for i in params[:protocols]
  #     for obj in objs
  #       if obj.protocol.id == i[:id]
  #         objs = objs - [obj]
  #         aux = true
  #         break
  #       end
  #     end
  #     if !aux
  #       ProtocolWallet.new({wallet: wallet, protocol_id: i[:id], percentage: 100}).save
  #     end
  #     aux = false
  #   end
  #   for obj in objs
  #     obj.destroy
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      #@group = @current_user.group_admins.first.group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:wallet_id, :plan_id, :saving_level_id, :savings, 
        :is_active, :b_count, :a_count, :customer_id, :c_name, :c_lastname, :c_document, 
        :c_rif, :c_rifnumber, :c_email, :c_localphone, :c_cellphone, :c1_name, :c1_lastname, 
        :c1_workstation, :c1_localphone, :c1_cellphone, :c1_email, :c2_name, :c2_lastname, 
        :c2_workstation, :c2_localphone, :c2_cellphone, :c2_email, :line_1, :line_2, 
        :country_id, :state_id, :city_id, :zipcode, :locale_id,
        :cc_localphone, :cc_c1_localphone, :cc_c2_localphone, :cc_cellphone, :cc_c1_cellphone, :cc_c2_cellphone)
    end

    def admin_params
      params.require(:admin).permit(:email, :password, :sq_1_id, :sq_2_id, :aq_1, :aq_2)
    end

    def admin2_params
      params.require(:admin2).permit(:email, :password, :sq_1_id, :sq_2_id, :aq_1, :aq_2)
    end

    def group_update_params
      params.require(:group).permit(:c1_name, 
        :c_name, :c_lastname, :c_document, :c_email, :c_localphone, :c_cellphone,
        :c1_lastname, :c1_workstation, :c1_localphone, 
        :c1_cellphone, :c1_email, :c2_name, :c2_lastname,
        :c2_workstation, :c2_localphone, :c2_cellphone, 
        :c2_email, :line_1, :line_2, :country_id, :state_id, :city_id, :zipcode,
        :cc_localphone, :cc_c1_localphone, :cc_c2_localphone, :cc_cellphone, :cc_c1_cellphone, :cc_c2_cellphone)
    end

end
