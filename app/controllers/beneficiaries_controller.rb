class BeneficiariesController < ApplicationController
  before_action :request_2!, only: [:show, :update, :get_creditcard, :put_creditcard, :delete_creditcard]
  before_action :request_1!, only: [:new_beneficiary_to_group, :beneficiary_to_group, :show_beneficiary_to_group, :update_beneficiary_in_group, :delete_beneficiary_to_group ]
  before_action :request_all!, only: [:show_wallet]
  before_action only: [:show, :update, :get_creditcard, :put_creditcard, :delete_creditcard] do  
    verify_correct_path_id(params[:id].to_i, [@current_user.id]) 
  end 
  before_action only: [:new_beneficiary_to_group, :beneficiary_to_group, :delete_beneficiary_to_group] do 
    verify_correct_path_id(params[:id].to_i, [@current_user.group_admins.first.group_id])   
  end 
  before_action only: [:update_beneficiary_in_group, :show_beneficiary_to_group] do 
    verify_correct_path_id(params[:group_id].to_i, [@current_user.group_admins.first.group_id])   
  end 
  before_action :set_beneficiary_2, only: [:show, :update, :get_creditcard, :put_creditcard, :delete_creditcard]
  before_action :set_beneficiary, only: [:update_beneficiary_in_group, :show_beneficiary_to_group]



  def show
    if @user.access_id != 69
      return render json: {errors: [Errors::translate(87)]}, status: :unprocessable_entity
    else
      super(@user, params[:locale], UserAccessBeneficiarySerializer)
    end
  end

  def show_wallet
    @user = UserAccess.find_by(wallet_id: params[:wallet_id])
    if @user.nil? or @user.access_id != 69
      render json: {errors: [Errors::translate(74)]}, status: :unprocessable_entity
    else
      super(@user, params[:locale], UserAccessBeneficiarySerializer)
    end
  end

  def create
    if beneficiary_is_valid?
      #Create beneficiary
      Gets::md5_encrypt(@beneficiary, :password, :aq_1, :aq_2)
      @beneficiary.save
      #Create Images
      picture = ImageAws::upload(params[:base64], Rails.configuration.route, Rails.configuration.bucket, "beneficiaries", "beneficiary-"+@beneficiary.id.to_s, nil, "defaults/undefineduser.png")
      @beneficiary.picture = picture
      @beneficiary.save
      #Create Wallet 
      wallet = Wallet.new()
      wallet.save
      #Create User Access (With wallet, and beneficiary)
      user_access = UserAccess.new({wallet: wallet, user: @beneficiary, access_id: 69, is_active: true})
      user_access.save
      #Adding Procotols
      for protocol in TblAttribute.where("tbl_attribute_id = 6")
        var = {wallet: wallet, protocol: protocol, percentage: 100}
        if protocol.id == 42
          ProtocolWallet.new(var).save if @beneficiary.gender_id == 68
        else
          ProtocolWallet.new(var).save
        end
      end
      locale = Gets::locale(params[:locale])
      #Charge wallet and create Transactions (Normal and Fee)
      wallet = Posts::change_code(@code, wallet, locale) if !@code.nil?      
      #Send Email
      #Thread.new do
        ModelMailer.send_welcome_beneficiary(
          @beneficiary, params[:password], wallet, @beneficiary.plan, @beneficiary.saving_level, locale).deliver
      #  ActiveRecord::Base.connection.close
      #end
      render json: {success: 1}, status: :created
    end
  end

  def beneficiary_is_valid?
    #Validate beneficiary Fields
    if (params[:sloncard_code] != nil) and (params[:sloncard_code] != "")
      @code = Checks::valid_code?(Sloncode, "code", params[:sloncard_code], "transac_id", 31, 32)
    else
      @code = nil
    end
    #Validate beneficiary Fields
    @beneficiary = Checks::valid?(Beneficiary, beneficiary_params, [:plan_id, 30])
    #Validate Image Fields
    if !params[:base64].nil?
      base64 = ImageAws::extension?(params[:base64], 20, 21)
    end
    #Errors of endpoints
    errors = []
    errors = @beneficiary if @beneficiary.class == Array 
    #errors << @protocols if @protocols.class == Integer
    if !params[:base64].nil?
      errors << Errors::translate(base64) if base64.class == Integer
    end
    errors << Errors::translate(@code) if @code.class == Integer
    if !errors.empty?
      render json: {errors: errors}, status: :unprocessable_entity
      return false
    else
      return true
    end
  end

  def get_creditcard
    render json: Gets::creditcard(@user.user)
  end

  def put_creditcard
    var = Puts::creditcard(params[:stripeToken], @user.user, @user.user.email, 50)
    if var == 50
      render json: {success: 2}, status: :ok
    else
      render json: {errors: [Errors::translate(50)]}, status: :ok
    end
  end

  def delete_creditcard
    var = Deletes::creditcard(@user.user, 51)
    if var == 51
      render json: {success: 3}, status: :ok
    else
      render json: {errors: [Errors::translate(51)]}, status: :ok
    end
  end

  def new_beneficiary_to_group
    if add_to_group_is_valid?
      #Create beneficiary
      Gets::md5_encrypt(@beneficiary, :password, :aq_1, :aq_2)
      @beneficiary.save
      #Create Images
      picture = ImageAws::upload(params[:base64], Rails.configuration.route, Rails.configuration.bucket, "beneficiaries", "beneficiary-"+@beneficiary.id.to_s, nil, "defaults/undefineduser.png")
      @beneficiary.picture = picture
      @beneficiary.save
      #Create Wallet 
      wallet = Wallet.new()
      wallet.save
      #Create User Access (With wallet, and beneficiary)
      user_access = UserAccess.new({wallet: wallet, user: @beneficiary, access_id: 69, is_active: true})
      user_access.save
      #Adding Procotols
      for protocol in TblAttribute.where("tbl_attribute_id = 6")
        var = {wallet: wallet, protocol: protocol, percentage: 100}
        if protocol.id == 42
          ProtocolWallet.new(var).save if @beneficiary.gender_id == 68
        else
          ProtocolWallet.new(var).save
        end
      end
      GroupBeneficiary.new({group: @group, beneficiary: user_access}).save
      @group.b_count = @group.group_beneficiaries.count
      @group.save
      locale = Gets::locale(params[:locale])     
      #Send Email
      #Thread.new do
        ModelMailer.send_welcome_beneficiary(
          @beneficiary, params[:password], wallet, @beneficiary.plan, @beneficiary.saving_level, locale).deliver
      #  ActiveRecord::Base.connection.close
      #end
      render json: {success: 1}, status: :created
    end
  end

  def add_to_group_is_valid?
    @beneficiary = Checks::valid?(Beneficiary, beneficiary_params, [:plan_id, 30], [:savings, 10], [:saving_level_id, 43])
    @user_access = Gets::user_access(params[:email], 69)
    @group = Gets::one(Group, "id", params[:id], nil, false, 52)
    base64 = ImageAws::extension?(params[:base64], 20, 21) 
    errors = []
    errors = @beneficiary if @beneficiary.class == Array 
    errors << Errors::translate(53) if @user_access
    if @group.class == Array
      errors += @group 
    else
      @group.plan_id == 31 ? ( count = 10 ) : ( count = 20 )
      errors << Errors::translate(54) if !(@group.group_beneficiaries.count < count)
    end
    errors << Errors::translate(base64) if base64.class == Integer
    if !errors.empty?
      render json: {errors: errors}, status: :unprocessable_entity
      return false
    else
      return true
    end
  end

  def beneficiary_to_group
    @user_access = Gets::user_access(params[:email], 69)
    @group = Gets::one(Group, "id", params[:id], nil, false, 52)
    errors = []
    errors << Errors::translate(89) if !@user_access
    if @group.class == Array
      errors += @group 
    else
      @group.plan_id == 31 ? ( count = 10 ) : ( count = 20 )
      errors << Errors::translate(54) if !(@group.group_beneficiaries.count < count)
    end
    begin
      b_exist = Gets::one(@group.group_beneficiaries, "beneficiary_id", @user_access.id, nil, false, 55)
      errors << Errors::translate(55) if b_exist.class == GroupBeneficiary
    rescue
    end
    if !errors.empty?
      render json: {errors: errors}, status: :unprocessable_entity
    else
      GroupBeneficiary.new({group: @group, beneficiary: @user_access}).save
      @group.b_count = @group.group_beneficiaries.count
      @group.save
      locale = Gets::locale(params[:locale]) 
      #Thread.new do
      #  ModelMailer.send_welcome_group_beneficiary(
      #    @group, @beneficiary, locale).deliver
      #    ActiveRecord::Base.connection.close
      #end  
      render json: {success: 1}, status: :created
    end
  end

  def delete_beneficiary_to_group
    @group = Gets::one(Group, "id", params[:id], nil, false, 52)
    errors = []
    errors += @group if @group.class == Array
    begin
      @group_beneficiary = Gets::one(@group.group_beneficiaries, "beneficiary_id", params[:beneficiary_id], nil, false, 56)
      errors << Errors::translate(56) if @group_beneficiary.class != GroupBeneficiary
    rescue
    end
    if !errors.empty?
      render json: {errors: errors}, status: :unprocessable_entity
    else
      @group_beneficiary.destroy
      @group.b_count = @group.group_beneficiaries.count
      @group.save
      render json: {success: 3}, status: :ok
    end
  end

  def update
    super(@user.user, beneficiary_update_params)
  end

  def update_beneficiary_in_group
    @group = Gets::one(Group, "id", params[:group_id], nil, false, 52)
    errors = []
    errors += @group if @group.class == Array
    begin
      @group_beneficiary = Gets::one(@group.group_beneficiaries, "beneficiary_id", params[:id], nil, false, 56)
      errors << Errors::translate(56) if @group_beneficiary.class != GroupBeneficiary
    rescue
    end
    if !errors.empty?
      render json: {errors: errors}, status: :unprocessable_entity
    else
      if @user.user.update(beneficiary_update_params)
        render json: {data: @user.user, success: 2}, status: :ok
      else
        render json: {errors: Gets::errors(@user.user.errors)}, status: :unprocessable_entity
      end
    end
  end

  def show_beneficiary_to_group
    @group = Gets::one(Group, "id", params[:group_id], nil, false, 52)
    errors = []
    errors += @group if @group.class == Array
    begin
      @group_beneficiary = Gets::one(@group.group_beneficiaries, "beneficiary_id", params[:id], nil, false, 56)
      errors << Errors::translate(56) if @group_beneficiary.class != GroupBeneficiary
    rescue
    end
    if !errors.empty?
      render json: {errors: errors}, status: :unprocessable_entity
    else
      render json: @user, serializer: UserAccessBeneficiarySerializer, scope: {'locale': @user.user.locale_id}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beneficiary
      @user = UserAccess.find(params[:id])
    end

    def set_beneficiary_2
      @user = @current_user
      #@user = UserAccess.find(params[:id])
    end

    def beneficiary_params
      params.require(:beneficiary).permit(:name ,:lastname ,:document ,:localphone ,
        :cellphone ,:profession ,:c1_name ,:c1_lastname ,:c1_localphone ,:c1_cellphone ,
        :c1_email ,:c2_name ,:c2_lastname ,:c2_localphone ,:c2_cellphone ,:c2_email ,
        :nationality ,:picture ,:email ,:password ,:sq_1_id ,:sq_2_id ,:aq_1 ,:aq_2 ,
        :line_1 ,:line_2 ,:country_id ,:state_id ,:city_id ,:zipcode ,:plan_id ,
        :saving_level_id ,:savings ,:locale_id ,:blood_type_id ,:birthday ,:race_id ,
        :weight ,:weight_unit_id ,:size ,:size_unit_id ,:gender_id,
        :cc_localphone, :cc_c1_localphone, :cc_c2_localphone, :cc_cellphone, :cc_c1_cellphone, :cc_c2_cellphone)
    end 

    def beneficiary_update_params
      params.require(:user).permit(
        :localphone, :cellphone, :nationality, :profession, 
        :weight, :weight_unit_id, 
        :size, :size_unit_id, :c1_name, :c1_lastname, 
        :c1_localphone, :c1_cellphone, :c1_email, 
        :c2_name, :c2_lastname, :c2_localphone, 
        :c2_cellphone, :c2_email, :line_1, :line_2, :country_id,
        :state_id ,:city_id ,:zipcode,
        :cc_localphone, :cc_c1_localphone, :cc_c2_localphone, :cc_cellphone, :cc_c1_cellphone, :cc_c2_cellphone)
    end

end
