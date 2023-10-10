class ItemsController < ApplicationController

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.require(:item).permit(:quantity, :price_init, :price_end, :checked, :tabulator_id, :service_order_id, :total)
    end
end
