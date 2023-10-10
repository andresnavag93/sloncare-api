class SuggestionsController < ApplicationController
  before_action :request_5!, only: [:pagination, :pagination_type]
  #before_action :set_user, only: [:create]

  def pagination
    super(Suggestion, params[:init], params[:end])
  end

  def pagination_type
    @offset = params[:init].to_i
    @limit = params[:end].to_i - @offset + 1
    suggestions = Suggestion.where("suggestion_type_id = ?", params[:suggestion_type_id]).order("created_at DESC").offset(@offset).limit(@limit) 
    render json: suggestions
  end

  # POST /suggestions
  def create
    @suggestion = Suggestion.new(suggestion_params)
    if !@suggestion.valid?
      render json: {errors: Gets::errors(@suggestion.errors)}, status: :unprocessable_entity
    else
      @suggestion.save
      locale = Gets::locale(params[:locale])
      begin
        email = User.find(1).email
        #email = Rails.configuration.slonemail
        ModelMailer.send_contact_request(
          @suggestion.email, @suggestion.name, @suggestion.description, locale, email, @suggestion.suggestion_type.name).deliver
        render json: {success: 1, email: email}, status: :created
      rescue
        render json: {success: 7, email: email}, status: :created
      end      
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_suggestion
      @suggestion = Suggestion.find(params[:id])
    end
    #def set_user
    #  if params[:user_access_id]
    #    @user = UserAccess.find(params[:user_access_id])
    #  else
    #    @user = nil
    #  end
    #end

    # Only allow a trusted parameter "white list" through.
    def suggestion_params
      params.require(:suggestion).permit(:user_access_id, :email, :name, :description, :suggestion_type_id)
    end
end
