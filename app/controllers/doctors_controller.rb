class DoctorsController < ApplicationController
  before_action :request_3!, only: [:show, :update]
  before_action only: [:show, :update] do  
    verify_correct_path_id(params[:id].to_i, [@current_user.id]) 
  end 
  before_action :set_doctor, only: [:show, :update]


  def showing_index
    list = Gets::user_many(UserAccess, 70)
    render json: list, each_serializer: DoctorPublicSerializer
  end

  def show
    if @user.access_id != 70
      return render json: {errors: [Errors::translate(87)]}, status: :unprocessable_entity
    else
      super(@user, params[:locale], UserAccessDoctorSerializer)
    end
  end

  def create   
    if doctor_is_valid?
      #Create Doctor
      Gets::md5_encrypt(@doctor, :password, :aq_1, :aq_2)
      @doctor.save
      #Create Image
      picture = ImageAws::upload(params[:base64], Rails.configuration.route, Rails.configuration.bucket, "doctors", "doctor-"+@doctor.id.to_s, nil, "defaults/undefineduser.png")
      #@doctor.picture = "https://s3.amazonaws.com/media.sloncare/doctors/doctor-5.jpeg"
      @doctor.picture = picture
      @doctor.save
      #Create Wallet 
      wallet = Wallet.new()
      wallet.save
      #Create User Access (With wallet, and doctor)
      user_access = UserAccess.new({wallet: wallet, user: @doctor, access_id: 70, is_active: false, visibility: false})
      user_access.save
      begin 
        UserSpecialty.new({user_access: user_access, specialty: @specialty, subspecialty: @subspecialty}).save
      rescue 
      end    

      #Create User Access Doctor-CLinic
      @clinics.each { |clinic| 
        begin DoctorClinic.new({doctor: user_access, clinic: clinic}).save 
        rescue 
        end }
      #Send Email
      locale = Gets::locale(params[:locale])
      #Thread.new do
        ModelMailer.send_welcome_doctor(@doctor, params[:password], wallet, locale).deliver
      #  ActiveRecord::Base.connection.close
      #end
      render json: {success: 1}, status: :created
    end
  end

  def doctor_is_valid?
    errors = []
    #Validate Doctor Fields
    @doctor = Checks::valid?(Doctor, doctor_params)
    #Validate Specialties
    #@specialties = Checks::multy_exists?(:specialties, 23, Specialty, 24, params)
    begin
      @specialty = Specialty.find(params[:specialty_id])
      @subspecialty = Specialty.find_by(specialty_id: @specialty.id)
      specialty_name = @subspecialty.name
      # HERE WE ARE SETTING MANUALLY SUBESPECIALTY BY SERVER
      # IN SLONCARE 3 WE HAVE TO VERIFY THIS
      #@subspecialty = Specialty.find(params[:subspecialty_id])
      #if @subspecialty.specialty_id != @specialty.id
      #  errors << (I18n.t 'custom_errors.doctor.specialty')
      #end
    rescue
      errors << (I18n.t 'custom_errors.doctor.specialty_errors')
    end
    #validate Image Fields
    base64 = ImageAws::extension?(params[:base64], 20, 21)
    #Validate Clinics
    @clinics = Checks::multy_exists?(:clinics, 25, User, 26, params)
    #Errors of endpoints
    errors += @doctor if @doctor.class == Array 
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
    custom_params = doctor_update_params
    if params[:base64] != nil
      base64 = ImageAws::extension?(params[:base64], 20, 21)
      errors = []
      errors << Errors::translate(base64) if base64.class == Integer
      if !errors.empty?
        return render json: {errors: errors}, status: :unprocessable_entity
      else      
        aux = custom_params[:picture].split(Rails.configuration.url_s3 + "/").last
        picture = ImageAws::upload(params[:base64], Rails.configuration.route, Rails.configuration.bucket, "doctors", "doctor-"+@user.id.to_s, aux, "defaults/image.png")
        custom_params[:picture] = picture
      end
    end
    # IN SLONCARE 3 WE HAVE TO VERIFY THIS UPDATE SPECIALTIES AND SUBESPECIALTIES
    # user_specialty = @user.user_specialties.first
    # if params[:specialty_id] != user_specialty.specialty_id
    #   user_specialty.specialty_id = params[:specialty_id]
    #   if params[:subspecialty_id] != user_specialty.subspecialty_id
    #     user_specialty.subspecialty_id = params[:subspecialty_id]
    #   end
    #   user_specialty.save
    #   user_specialty.user_tabs.destroy_all
    # end
    begin
      @user.visibility = params[:visibility]
      @user.save
    rescue
    end
    super(@user.user, custom_params)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctor
      @user = @current_user
      #@user = UserAccess.find(params[:id])
    end

    def doctor_params
      params.require(:doctor).permit(:name, :lastname, :localphone, :cellphone, 
        :rif, :rifnumber, :document, :ms_id, :nationality, :picture, :email, :locale_id,
        :password, :sq_1_id, :sq_2_id, :aq_1, :aq_2, :line_1, :line_2, :country_id, 
        :state_id, :city_id, :zipcode, :mh_permit_id, :subespecialty_field,
        :cc_localphone, :cc_cellphone)      
    end

    def doctor_update_params
      params.require(:user).permit(:picture, :line_1, :line_2, :country_id,
        :state_id, :city_id, :zipcode, :localphone, :cellphone,
        :cc_localphone, :cc_cellphone)    
    end
end
