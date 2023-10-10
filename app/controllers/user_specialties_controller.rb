class UserSpecialtiesController < ApplicationController

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_specialty
      @user_specialty = UserSpecialty.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_specialty_params
      params.require(:user_specialty).permit(:user_access_id, :specialty_id, :subspecialty_id)
    end
end
