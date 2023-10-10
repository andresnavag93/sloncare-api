class GroupAdminsController < ApplicationController

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_admin
      @group_admin = GroupAdmin.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_admin_params
      params.require(:group_admin).permit(:group_id, :admin_id)
    end
end
