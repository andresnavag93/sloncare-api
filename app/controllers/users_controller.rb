class UsersController < ApplicationController

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter white list" through.
    def user_params
      params.require(:user).permit(:profession, :name, :lastname, :businessname, :localphone, :cellphone, :rif, :document, :d_name, :d_lastname, :d_document, :d_phone, :d_email, :d_picture, :c1_name, :c1_lastname, :c1_workstation, :c1_localphone, :c1_cellphone, :c1_email, :c2_name, :c2_lastname, :c2_workstation, :c2_localphone, :c2_cellphone, :c2_email, :mh_permit, :ms_id, :nationality, :picture, :email, :password, :sq_1_id, :sq_2_id, :aq_1, :aq_2, :line_1, :line_2, :country_id, :state_id, :city_id, :zipcode, :customer_id, :plan_id, :saving_level_id, :savings, :locale_id, :blood_type_id, :birthday, :race_id, :weight, :weight_unit_id, :size, :size_unit_id, :gender_id)
    end

end
