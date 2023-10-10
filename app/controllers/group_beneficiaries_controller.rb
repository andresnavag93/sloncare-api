class GroupBeneficiariesController < ApplicationController

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_beneficiary
      @group_beneficiary = GroupBeneficiary.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_beneficiary_params
      params.require(:group_beneficiary).permit(:group_id, :beneficiary_id)
    end
end
