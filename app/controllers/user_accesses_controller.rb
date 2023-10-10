class UserAccessesController < ApplicationController
  before_action :request_7!, only: [ :admin_create, :admin_index, :admin_delete ]
  before_action :request_9!, only: [:admin_show, :inactive_providers,  :active_providers, :inactive_user, :user_show, :user_wallet_show]
  before_action :set_user_access, only: [:admin_update, :admin_delete, :inactive_user, :admin_show, :user_show]

  # # GET /groups
  def true
   render json: {success: 1}
  end

  def admin_index
    admins = UserAccess.where("access_id in (?)", [75, 76, 77])
    render json: admins.includes(:user), each_serializer: AdministratorSerializer
  end

  def admin_show
    if ![73, 75, 76, 77].include? @user_access.access_id
      render json: {errors: [Errors::translate(80)]}, status: :unprocessable_entity
    else
      render json: @user_access, serializer: AdministratorSerializer
    end
  end

  def admin_create
    user = Checks::valid?(User, user_params)
    if user.class == Array 
      render json: {errors: user}, status: :unprocessable_entity
    elsif ![75, 76, 77].include? params[:access_id].to_i
      render json: {errors: [Errors::translate(80)]}, status: :unprocessable_entity
    else
      Gets::md5_encrypt(user, :password, :aq_1, :aq_2)
      user.save
      user_access = UserAccess.new({user: user, access_id: params[:access_id], visibility:true, is_active:true })
      user_access.save
      render json: {success: 1}, status: :created
    end
  end

  def admin_delete
    if ![75, 76, 77].include? @user_access.access_id
      return render json: {errors: [Errors::translate(93)]}, status: :unprocessable_entity
    elsif @current_user.id == params[:id].to_i
      return render json: {errors: [Errors::translate(99)]}, status: :unprocessable_entity
    else
      @user_access.user.destroy
      render json: {success: 3}, status: :ok
    end
  end

  def inactive_providers
    @offset = params[:init].to_i
    @limit = params[:end].to_i - @offset + 1
    users = UserAccess.where("access_id in (?)", [70, 71, 74]).where("is_active = ?", false).offset(@offset).limit(@limit)
    render json: users.includes(:user), each_serializer: UserSerializer
  end

  def active_providers
    @offset = params[:init].to_i
    @limit = params[:end].to_i - @offset + 1
    users = UserAccess.where("access_id in (?)", [70, 71, 74]).where("is_active = ?", true).offset(@offset).limit(@limit)
    render json: users.includes(:user), each_serializer: UserSerializer
  end

  def user_show
    if ![70, 71, 74].include? @user_access.access_id
      render json: {errors: [Errors::translate(94)]}, status: :unprocessable_entity
    elsif @user_access.access_id == 70
      render json: @user_access, serializer: UserAccessDoctorSerializer, scope: {'locale': @user_access.user.locale_id}
    elsif @user_access.access_id == 71
      render json: @user_access, serializer: UserAccessClinicSerializer, scope: {'locale': @user_access.user.locale_id}
    elsif @user_access.access_id == 74
      render json: @user_access, serializer: UserAccessProviderSerializer, scope: {'locale': @user_access.user.locale_id}
    end
  end

  def user_wallet_show
    @user_access = UserAccess.find_by(wallet_id: params[:id])
    if !@user_access
      @group = Group.find_by(wallet_id: params[:id])
      if @group 
        render json: @group, scope: {'locale': @group.locale_id}
      else
        render json: []
      end
    elsif @user_access.access_id == 70
      render json: @user_access, serializer: UserAccessDoctorSerializer, scope: {'locale': @user_access.user.locale_id}
    elsif @user_access.access_id == 71
      render json: @user_access, serializer: UserAccessClinicSerializer, scope: {'locale': @user_access.user.locale_id}
    elsif @user_access.access_id == 74
      render json: @user_access, serializer: UserAccessProviderSerializer, scope: {'locale': @user_access.user.locale_id}
    elsif @user_access.access_id == 69
      render json: @user_access, serializer: UserAccessBeneficiarySerializer, scope: {'locale': @user_access.user.locale_id}
    else
      render json: []
    end
  end

  def inactive_user
    @user_access.is_active = params[:is_active]
    @user_access.save
    render json: {success: 2}, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_access
      @user_access = UserAccess.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_access_params
      params.require(:user_access).permit(:access_id, :is_active, :visibility)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :aq_1, :aq_2, :birthday, :sq_1_id, :sq_2_id, :locale_id, :country_id, :state_id, :city_id)
    end
end
