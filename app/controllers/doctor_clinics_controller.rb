class DoctorClinicsController < ApplicationController

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctor_clinic
      @doctor_clinic = DoctorClinic.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def doctor_clinic_params
      params.require(:doctor_clinic).permit(:doctor_id, :clinic_id)
    end
end
