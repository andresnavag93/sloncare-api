class RecoveryPasswordsController < ApplicationController
  before_action :request_all_recovery!, only: [:verify_answers, :change_recovery_password, :change_user_password, :security_questions]
  before_action :request_all!, only: [:change_user_password]

  def send_email()
    user = User.where("email = ?", params[:email])
    if user.exists?
      access = UserAccess.where("user_id = ?", user[0].id)
      token = payload_token(access[0])
      access[0].verify_token = token[:token]
      access[0].save
      locale = Gets::locale(params[:locale])
      #Thread.new do
        ModelMailer.send_token_email(
          user[0].email, token[:token], user[0].sq_1_id, user[0].sq_2_id, locale).deliver
      #end
      render json: {success: 1}, status: :ok
    else
      render json: {errors: [Errors::translate(41)]}, status: :unauthorized
    end    
  end

  def security_questions
    if @current_user.verify_token == nil or @current_user.verify_token != http_token
      render json: { errors: [Errors::translate(43)] }, status: :unauthorized
    elsif @current_user.user.sq_1_id == auth_token[:sq_1_id] && @current_user.user.sq_2_id == auth_token[:sq_2_id]
      @objs = TblAttribute.where("id in (?)", [@current_user.user.sq_1_id, @current_user.user.sq_2_id])
      render json: @objs, each_serializer: TblAttributeSerializer, status: :ok
    else
      render json: {errors: [Errors::translate(43)]}, status: :unauthorized
    end
  end

  def verify_answers
    if @current_user.verify_token == nil or @current_user.verify_token != http_token
      render json: { errors: [Errors::translate(43)] }, status: :unauthorized
    elsif @current_user.user.sq_1_id == auth_token[:sq_1_id] && @current_user.user.sq_2_id == auth_token[:sq_2_id]
      answer2 = Digest::MD5.hexdigest(params[:answer2].to_s)
      answer1 = Digest::MD5.hexdigest(params[:answer1].to_s) 
      if @current_user.user.aq_1 == answer1 && @current_user.user.aq_2 == answer2
        token = payload_change_password(@current_user)
        @current_user.verify_token = token
        @current_user.save
        render json: {success: 1, token: token}, status: :ok
      else
        render json: {errors: [Errors::translate(47)]}, status: :unauthorized
      end
    else
      render json: {errors: [Errors::translate(43)]}, status: :unauthorized
    end
  end

  def change_recovery_password
    if @current_user.verify_token == nil or @current_user.verify_token != http_token
      render json: { errors: [Errors::translate(43)] }, status: :unauthorized
    elsif auth_token[:valid_change]
      if @current_user.user.sq_1_id == auth_token[:sq_1_id] && @current_user.user.sq_2_id == auth_token[:sq_2_id]
        if params[:password] == params[:verify_password]
          password = Digest::MD5.hexdigest(params[:password].to_s)
          @current_user.user.password = password 
          @current_user.user.save 
          locale = Gets::locale(params[:locale])
          #Thread.new do
            ModelMailer.send_password_change(@current_user.user.email,locale).deliver
          #  ActiveRecord::Base.connection.close
          #end
          @current_user.verify_token = nil
          @current_user.save
          render json: {success: 2}, status: :ok
        else
          render json: {errors: [Errors::translate(48)]}, status: :unauthorized
        end
      else
        render json: {errors: [Errors::translate(43)]}, status: :unauthorized
      end
    else
      render json: {errors: [Errors::translate(43)]}, status: :unauthorized
    end
  end

  def change_user_password
    old_password = Digest::MD5.hexdigest(params[:old_password].to_s)
    if old_password == @current_user.user.password
      if params[:password] == params[:verify_password]
        password = Digest::MD5.hexdigest(params[:password].to_s)
        @current_user.user.password = password 
        @current_user.user.save 
        locale = Gets::locale(params[:locale])
        #Thread.new do
          ModelMailer.send_password_change(@current_user.user.email, locale).deliver
        #  ActiveRecord::Base.connection.close
        #end
        render json: {success: 2}, status: :ok
      else
        render json: {errors: [Errors::translate(48)]}, status: :unauthorized
      end
    else
      render json: {errors: [Errors::translate(23)]}, status: :unauthorized
    end
  end

  private
    def payload_token(user)
      return nil unless user and user.id
      time = Time.now.to_i + 3600
      return {
        token: JsonWebToken.encode({
        user_id: user.id, 
        sq_1_id: user.user.sq_1_id, 
        sq_2_id: user.user.sq_2_id, 
        role_id: user.access_id}, time)
      }
    end

    def payload_change_password(user)
      return nil unless user and user.id
      time = Time.now.to_i + 3600
      return JsonWebToken.encode({
        user_id: user.id, 
        valid_change: true,
        sq_1_id: user.user.sq_1_id, 
        sq_2_id: user.user.sq_2_id, 
        role_id: user.access_id}, time)
    end
end
