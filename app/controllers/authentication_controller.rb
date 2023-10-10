class AuthenticationController < ApplicationController
  before_action :request_all!, only: [:logout, :verify_token]

  def auth_user
    user = User.find_by(email: params[:email])
    if !user.nil?
      access = UserAccess.find_by(user_id: user.id)
      if !access.nil?
        if !access.is_active
          render json: { errors: [Errors::translate(95)] }, status: :unauthorized
          return
        elsif access.login_tries < 3
          return valid_password?(params[:password], user, access)
        elsif access.login_tries >= 3
          if access.try_expires < Time.now
            return valid_password?(params[:password], user, access, 0)
          else
            return render json: {errors: [Errors::translate(79)]}, status: :unauthorized
          end
        end
      else
        return render json: {errors: [Errors::translate(41)]}, status: :unauthorized
      end
    else
      return render json: {errors: [Errors::translate(41)]}, status: :unauthorized
    end
  end

  def auth_user_admin
    user = User.find_by(email: params[:email])
    if !user.nil?
      access = UserAccess.find_by(user_id: user.id)
      if !access.nil? and [73,75,76,77].include? access.access_id
        if !access.is_active
          render json: { errors: [Errors::translate(95)] }, status: :unauthorized
          return
        elsif access.login_tries < 3
          return valid_password?(params[:password], user, access)
        elsif access.login_tries >= 3
          if access.try_expires < Time.now
            return valid_password?(params[:password], user, access, 0)
          else
            return render json: {errors: [Errors::translate(79)]}, status: :unauthorized
          end
        end
      else
        return render json: {errors: [Errors::translate(41)]}, status: :unauthorized
      end
    else
      return render json: {errors: [Errors::translate(41)]}, status: :unauthorized
    end
  end

  def valid_password?(password, user, access, try=nil)
    confirm = Digest::MD5.hexdigest(password.to_s)
    if (confirm == user.password) 
      token = payload(access)
      access.login_tries = 0
      access.try_expires = nil
      access.auth_token = token[:token]
      access.save
      return render json: token
    else
      access.login_tries = 0 if !try.nil?
      access.login_tries += 1
      access.try_expires = (Time.now + 600) if access.login_tries == 3
      access.save
      return render json: {errors: [Errors::translate(42)], tries: access.login_tries}, status: :unauthorized
    end
  end

  def verify_token
    begin
      unless user_id_in_token?
        render json: {errors: [Errors::translate(43)]}, status: :unauthorized
        return
      end
      render json: {success: 5}, status: :ok
      return
    rescue JWT::VerificationError, JWT::DecodeError 
      render json: {errors: [Errors::translate(43)]}, status: :unauthorized
      return
    end
  end

  def logout
    @current_user.auth_token = nil
    @current_user.save
    render json: {}
  end

  private

    def payload(user)
      return nil unless user and user.id
      if [73, 76, 77, 78].include? user.access_id
        time = Time.now.to_i + 3600*24
      else
        time = Time.now.to_i + 1800
      end
      val = {user_id: user.id, role_id: user.access_id}
      if user.access_id == 72
        a = GroupAdmin.where("admin_id = ?",user.id)
        val[:group_id] = a[0].group_id
      end
      jwt = { token: JsonWebToken.encode(val, time) }
      return jwt
    end
    
end
