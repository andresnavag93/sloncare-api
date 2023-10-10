class SponsorsController < ApplicationController

  def landing_email_server
    locale = Gets::locale(params[:locale])
    begin
      email = User.find(1).email
      #email = Rails.configuration.admin_mail
      ModelMailer.send_contact_request(
        params[:email], params[:name], params[:text], locale, email).deliver
      render json: {data: {email: params[:email]}, success: 1}, status: :created
    rescue
      render json: {data: {email: params[:email]}, success: 7}, status: :created
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sponsor
      @sponsor = Sponsor.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sponsor_params
      params.require(:sponsor).permit(:email, :name, :phone, :document, :country_id, :country_code, :cc_phone)
    end
end
