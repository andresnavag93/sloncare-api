class LocationsController < ApplicationController
  before_action :set_location, only: [:show]

  def search_countries
    attributes_search(Location, "location_id is ?", nil, params[:locale].to_i )
  end

  def search_root
    attributes_search(Location, "location_id = ?", params[:id], params[:locale].to_i )
  end

  def show
    super(@location, params[:locale])
  end

  # GET /tbl_attributes/
  def index
    super(Location, params[:locale])
  end

  private
    def set_location
      @location = Location.find(params[:id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def attributes_search(model, string, variable, locale=nil)
      if !locale.nil? and locale == 29
        @objs = model.where(string, variable).order("name_en")
      else
        @objs = model.where(string, variable).order("name")
      end
      render json: @objs, scope: {'locale': locale}
    end

    # Only allow a trusted parameter "white list" through.
    def location_params
      params.require(:location).permit(:name, :value, :name_en, :value_en, :location_id)
    end
end
