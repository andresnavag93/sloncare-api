class ImagenDocsController < ApplicationController

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image_doc
      @imagen_doc = ImagenDoc.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def image_doc_params
      params.require(:image_doc).permit(:service_order_id, :name, :image_type)
    end
end
