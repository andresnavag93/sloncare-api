class ProtocolWalletsController < ApplicationController

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_protocol_wallet
      @protocol_wallet = ProtocolWallet.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def protocol_wallet_params
      params.require(:protocol_wallet).permit(:wallet_id, :protocol_id, :percentage)
    end
end
