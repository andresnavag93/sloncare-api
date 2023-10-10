class ProvidersController < ApplicationController
  before_action :request_6!, only: [:show, :update]
  before_action only: [:show, :update] do  
    verify_correct_path_id(params[:id].to_i, [@current_user.id]) 
  end
  before_action :set_provider, only: [:show, :update]


  def show
    if @user.access_id != 74
      return render json: {errors: [Errors::translate(87)]}, status: :unprocessable_entity
    else
      super(@user, params[:locale], UserAccessProviderSerializer)
    end
  end

  def create
    if provider_is_valid?
      #Create provider
      Gets::md5_encrypt(@provider, :password, :aq_1, :aq_2)
      @provider.save
      #Create Image
      picture = ImageAws::upload(params[:base64], Rails.configuration.route, Rails.configuration.bucket, "providers", "provider-"+@provider.id.to_s, nil, "defaults/undefineduser.png")
      #@provider.picture = "https://s3.amazonaws.com/media.sloncare/providers/provider-5.jpeg"
      @provider.picture = picture
      @provider.save
      #Create Wallet 
      wallet = Wallet.new()
      wallet.save
      #Create User Access (With wallet, and provider)
      user_access = UserAccess.new({wallet: wallet, user: @provider, access_id: 74, is_active: false, visibility: false})
      user_access.save
      #Create User Access provider-Specialties
      begin 
        UserSpecialty.new({user_access: user_access, specialty: @specialty}).save
      rescue 
      end   
      #Send Email
      locale = Gets::locale(params[:locale])
      #Thread.new do
        ModelMailer.send_welcome_doctor(@provider, params[:password], wallet, locale).deliver
      #  ActiveRecord::Base.connection.close
      #end
      render json: {success: 1}, status: :created
    end
  end

  def provider_is_valid?
    errors = []
    #Validate provider Fields
    @provider = Checks::valid?(Provider, provider_params)
    #Validate Specialties
    #@specialties = Checks::multy_exists?(:specialties, 23, Specialty, 24, params)
    begin
      @specialty = Specialty.find(params[:specialty_id])
    rescue
      errors << Errors::translate(61)
    end
    #Validate Image Fields
    base64 = ImageAws::extension?(params[:base64], 20, 21)
    #Errors of endpoints
    errors += @provider if @provider.class == Array 
    #errors << @specialties if @specialties.class == Integer
    errors << Errors::translate(base64) if base64.class == Integer
    #errors << @clinics if @clinics.class == Integer
    if !errors.empty?
      render json: {errors: errors}, status: :unprocessable_entity
      return false
    else
      return true
    end
  end

  def update
    custom_params = provider_update_params
    if params[:base64] != nil
      base64 = ImageAws::extension?(params[:base64], 20, 21)
      errors = []
      errors << Errors::translate(base64) if base64.class == Integer
      if !errors.empty?
        return render json: {errors: errors}, status: :unprocessable_entity
      else      
        aux = custom_params[:picture].split(Rails.configuration.url_s3 + "/").last
        picture = ImageAws::upload(params[:base64], Rails.configuration.route, Rails.configuration.bucket, "providers", "provider-"+@user.id.to_s, aux, "defaults/image.png")
        custom_params[:picture] = picture
      end
    end
    # IN SLONCARE 3 WE HAVE TO VERIFY THIS UPDATE SPECIALTIES
    #user_specialty = @user.user_specialties.first
    #if params[:specialty_id] != user_specialty.specialty_id
    #  user_specialty.specialty_id = params[:specialty_id]
    #  user_specialty.save
    #end
    begin
      @user.visibility = params[:visibility]
      @user.save
    rescue
    end
    super(@user.user, custom_params)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider
      @user = @current_user
      #@user = UserAccess.find(params[:id])
    end

    def provider_params
      params.require(:provider).permit(:name, :lastname, :localphone, :cellphone, :businessname, 
        :rif, :rifnumber, :document, :picture, :email, 
        :password, :sq_1_id, :sq_2_id, :aq_1, :aq_2, :line_1, :line_2, :country_id, 
        :state_id, :city_id, :zipcode, :locale_id,
        :cc_localphone, :cc_cellphone)    
    end

    def provider_update_params
      params.require(:user).permit(:picture, :line_1, :line_2, :country_id,
        :state_id, :city_id, :zipcode, :localphone, :cellphone,
        :cc_localphone, :cc_cellphone)     
    end
end
