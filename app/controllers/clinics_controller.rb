class ClinicsController < ApplicationController
  before_action :request_4!, only: [:show, :update]
  before_action only: [:show, :update] do  
    verify_correct_path_id(params[:id].to_i, [@current_user.id]) 
  end 
  before_action :set_clinic, only: [:show, :update]
  
  
  def showing_index
    list = Gets::user_many(UserAccess, 71)
    render json: list, each_serializer: ClinicPublicSerializer
  end

  def show
    if @user.access_id != 71
      return render json: {errors: [Errors::translate(87)]}, status: :unprocessable_entity
    else
      super(@user, params[:locale], UserAccessClinicSerializer)
    end
  end

  def create
    if clinic_is_valid?
      #Create clinic
      Gets::md5_encrypt(@clinic, :password, :aq_1, :aq_2)
      @clinic.save
      #Create Images
      picture = ImageAws::upload(params[:base64], Rails.configuration.route, Rails.configuration.bucket, "clinics", "clinic-"+@clinic.id.to_s, nil, "defaults/undefineduser.png")
      d_picture = ImageAws::upload(params[:base64_2], Rails.configuration.route, Rails.configuration.bucket, "clinics", "clinic-director-"+@clinic.id.to_s, nil, "defaults/undefineduser.png")
      mh_permit = ImageAws::upload(params[:base64_3], Rails.configuration.route, Rails.configuration.bucket, "clinics", "clinic-mh-permit-"+@clinic.id.to_s, nil, "defaults/undefineduser.png")
      @clinic.picture = picture
      @clinic.d_picture = d_picture
      @clinic.mh_permit = mh_permit
      @clinic.save
      #Create Wallet 
      wallet = Wallet.new()
      wallet.save
      #Create User Access (With wallet, and clinic)
      user_access = UserAccess.new({wallet: wallet, user: @clinic, access_id: 71, is_active: false, visibility: false})
      user_access.save
      #Create User Access Clinic-Specialties
      @specialties.each {|specialty| 
        begin
          if user_access.user_specialties.find_by(specialty_id: specialty.id).nil? 
            UserSpecialty.new({user_access: user_access, specialty: specialty}).save 
          end
        rescue 
        end }
      #Send Email
      locale = Gets::locale(params[:locale])
      #Thread.new do
        ModelMailer.send_welcome_clinic(@clinic, params[:password], wallet, locale).deliver
      #  ActiveRecord::Base.connection.close
      #end
      render json: {success: 1}, status: :created
    end
  end

  def clinic_is_valid?
    #Validate Clinic Fields
    @clinic = Checks::valid?(Clinic, clinic_params)
    #Validate Specialties
    @specialties = Checks::multy_exists?(:specialties, 23, Specialty, 24, params)
    #Validate Image Fields
    base64 = ImageAws::extension?(params[:base64], 20, 21)
    base64_2 = ImageAws::extension?(params[:base64_2], 27, 28)
    base64_3 = ImageAws::extension?(params[:base64_3], 29, 30)
    #Errors of endpoints
    errors = []
    errors = @clinic if @clinic.class == Array 
    errors << Errors::translate(@specialties) if @specialties.class == Integer
    errors << Errors::translate(base64) if base64.class == Integer
    errors << Errors::translate(base64_2) if base64_2.class == Integer
    errors << Errors::translate(base64_3) if base64_3.class == Integer
    #errors << @clinics if @clinics.class == Integer
    if !errors.empty?
      render json: {errors: errors}, status: :unprocessable_entity
      return false
    else
      return true
    end
  end

  def update
    custom_params = clinic_update_params
    
    # SLONCARE 3 THINK TO UPDATE CLINIC SPECIALTIES
    #if params[:specialties] != nil
    #  errors = []
    #  @specialties = Checks::multy_exists?(:specialties, 23, Specialty, 24, params)
    #  errors << Errors::translate(@specialties) if @specialties.class == Integer
    #  if !errors.empty?
    #    return render json: {errors: errors}, status: :unprocessable_entity
    #  end 
    #   user_specialties = @user.user_specialties
    #   for specialty in @specialties
    #     aux = false
    #     for user_specialty in user_specialties
    #       if specialty.id == user_specialty.specialty_id
    #         user_specialties = user_specialties - [user_specialty]
    #         aux = true
    #         break
    #       end
    #     end
    #     if !aux 
    #       begin 
    #         if @user.user_specialties.find_by(specialty_id: specialty.id).nil? 
    #           UserSpecialty.new({user_access: @user, specialty: specialty}).save 
    #         end
    #       rescue 
    #       end 
    #     end
    #   end
    #   for obj in user_specialties
    #     obj.destroy
    #   end
    # end

    if params[:base64] != nil
      base64 = ImageAws::extension?(params[:base64], 20, 21)
      errors = []
      errors = [base64] if base64.class == Integer
      if !errors.empty?
        return render json: {errors: errors}, status: :unprocessable_entity
      else      
        aux = custom_params[:picture].split(Rails.configuration.url_s3 + "/").last
        picture = ImageAws::upload(params[:base64], Rails.configuration.route, Rails.configuration.bucket, "clinics", "clinic-"+@user.id.to_s, aux, "defaults/image.png")
        custom_params[:picture] = picture
      end
    end

    if params[:base64_2] != nil
      base64 = ImageAws::extension?(params[:base64_2], 20, 21)
      errors = []
      errors = [base64] if base64.class == Integer
      if !errors.empty?
        return render json: {errors: errors}, status: :unprocessable_entity
      else      
        aux = custom_params[:d_picture].split(Rails.configuration.url_s3 + "/").last
        picture = ImageAws::upload(params[:base64_2], Rails.configuration.route, Rails.configuration.bucket, "clinics", "clinic-"+@user.id.to_s, aux, "defaults/image.png")
        custom_params[:d_picture] = picture
      end
    end

    if params[:base64_3] != nil
      base64 = ImageAws::extension?(params[:base64_3], 20, 21)
      errors = []
      errors = [base64] if base64.class == Integer
      if !errors.empty?
        return render json: {errors: errors}, status: :unprocessable_entity
      else      
        aux = custom_params[:mh_permit].split(Rails.configuration.url_s3 + "/").last
        picture = ImageAws::upload(params[:base64_3], Rails.configuration.route, Rails.configuration.bucket, "clinics", "clinic-"+@user.id.to_s, aux, "defaults/image.png")
        custom_params[:mh_permit] = picture
      end
    end

    begin
      @user.visibility = params[:visibility]
      @user.save
    rescue
    end
    super(@user.user, custom_params)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clinic
      @user = @current_user
      #@user = UserAccess.find(params[:id])
    end

    def clinic_params
      params.require(:clinic).permit(:name, :businessname , :localphone , :rif , :rifnumber , :d_name , 
        :d_lastname , :d_document , :d_phone , :d_email , :d_picture , :c1_name , :c1_lastname , :c1_workstation , 
        :c1_localphone , :c1_cellphone , :c1_email , :c2_name , :c2_lastname , :c2_workstation , 
        :c2_localphone , :c2_cellphone , :c2_email , :mh_permit , :picture , :email , :password , 
        :sq_1_id , :sq_2_id , :aq_1 , :aq_2 , :line_1 , :line_2 , :country_id , :state_id , 
        :city_id , :zipcode , :locale_id, :mh_permit_id, :clinic_role_id,
        :cc_localphone, :cc_c1_localphone, :cc_c2_localphone, :cc_c1_cellphone, :cc_c2_cellphone, :cc_d_phone)
    end

    def clinic_update_params
      params.require(:user).permit(:localphone, :d_name , :d_lastname , :d_document , :d_phone , :d_email , :d_picture , 
        :c1_name , :c1_lastname , :c1_workstation , :c1_localphone , :c1_cellphone , :c1_email , :c2_name , 
        :c2_lastname , :c2_workstation , :c2_localphone , :c2_cellphone , :c2_email , :mh_permit , :picture ,
        :line_1 , :line_2 , :country_id , :state_id , :city_id , :zipcode , :locale_id, :clinic_role_id,
        :cc_localphone, :cc_c1_localphone, :cc_c2_localphone, :cc_c1_cellphone, :cc_c2_cellphone, :cc_d_phone)
    end
end
