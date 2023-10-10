class TblAttributesController < ApplicationController
  before_action :request_5!, only: [:create, :update]
  before_action :set_tbl_attribute, only: [:update]

  def create
    super(TblAttribute, tbl_attribute_params)
  end

  def update
    super(@tbl_attribute, tbl_attribute_params)
  end

  def search_root
    attributes_search(TblAttribute, "tbl_attribute_id = ?", params[:id], params[:locale].to_i )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tbl_attribute
      @tbl_attribute = TblAttribute.find(params[:id])
    end

    def attributes_search(model, string, variable, locale=nil)
      if !locale.nil? and locale == 29
        @objs = model.where(string, variable).order("name_en")
      else
        @objs = model.where(string, variable).order("name")
      end
      render json: @objs, scope: {'locale': locale}
    end

    def tbl_attribute_params
      params.require(:tbl_attribute).permit(:name, :value, :amount, :tbl_attribute_id, :value_en, :name_en)
    end

end
