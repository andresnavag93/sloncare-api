class SloncodesController < ApplicationController

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sloncode
      @sloncode = Sloncode.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sloncode_params
      params.require(:sloncode).permit(:p_reference, :code, :price, :fee, :encrypt_id, :payment_id, :transac_id, :currency_id)
    end
end
