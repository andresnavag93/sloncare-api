class ApplicationController < ActionController::API
  attr_reader :current_user
  before_action :set_locale

  include ApiMethods

  protected
    def general_request(list, recovery=nil)
      if Rails.configuration.permisology
        begin
          unless user_id_in_token?
            render json: { errors: [Errors::translate(98)] }, status: :not_acceptable
            return
          end
          @auth_token = auth_token
          if list.include? (@auth_token[:role_id])
            @current_user = UserAccess.find(@auth_token[:user_id])
            if !@current_user.is_active
              render json: { errors: [Errors::translate(95)] }, status: :not_acceptable
              return
            elsif !recovery
              if @current_user.auth_token == nil
                render json: { errors: [Errors::translate(44)] }, status: :not_acceptable
                return
              elsif @current_user.auth_token != http_token
                render json: { errors: [Errors::translate(45)] }, status: :not_acceptable
                return
              end
            end
          else
            render json: { errors: [Errors::translate(46)] }, status: :unauthorized
            return
          end
        rescue JWT::VerificationError, JWT::DecodeError 
          raise render json: { errors: [Errors::translate(98)] }, status: :not_acceptable
        end
      end
    end

    def verify_correct_path_id(id, list)
      if Rails.configuration.permisology
        if @auth_token[:role_id] != 73
          if !(list.include? id)
            render json: { errors: [Errors::translate(87)] }, status: :unauthorized
            return
          end
        end
      end
    end

    def request_all!
      general_request([69, 70, 71, 72, 73, 74, 75, 76, 77, 78])
    end

    def request_all_recovery!
      general_request([69, 70, 71, 72, 73, 74, 75, 76, 77, 78], true)
    end

    def request_1! #Group Admin
      general_request([72, 73])
    end

    def request_2! #Beneficiary
      general_request([69, 73])
    end

    def request_3! #Doctor
      general_request([70, 73])
    end

    def request_4! #Clinic
      general_request([71, 73])
    end

    def request_5! #Slon Admin
      general_request([73])
    end

    def request_6! #Provider Admin
      general_request([74, 73])
    end

    def request_7! #General Manager Admin
      general_request([75, 73])
    end

    def request_8! #Analyst 1 Admin
      general_request([76, 75, 73])
    end

    def request_9! #Analyst 2 Admin
      general_request([77, 76, 75, 73])
    end

    def request_12! #Group Beneficiary Admin
      general_request([69, 72, 73])
    end

    def request_346! #Group Beneficiary Admin
      general_request([70, 71, 73, 74])
    end

    def request_12346! #Group Beneficiary Admin
      general_request([69, 70, 71, 72, 73, 74])
    end

  private

    def set_locale 
      locale = Gets::locale(params[:locale])
      I18n.locale = locale.to_sym  
    end

		def http_token
			http_token ||= if request.headers['Authorization'].present?
			  request.headers['Authorization'].split('JWT ').last
			end
		end

		def auth_token
			auth_token ||= JsonWebToken.decode(http_token)
		end

		def user_id_in_token?
			http_token && auth_token && auth_token[:user_id].to_i && auth_token[:role_id].to_i 
		end
end