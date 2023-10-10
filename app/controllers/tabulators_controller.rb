class TabulatorsController < ApplicationController
  before_action :request_12!, only: [:search_services, :index_tabulators, :search_services_records, :search_providers]
  before_action :request_5!, only: [:create, :update]
  before_action :set_tabulator, only: [:update]

  def create
    super(Tabulator, tabulator_params)
  end

  def update
    super(@tabulator, tabulator_params)
  end

  def search_services
    attributes_search(Tabulator, "service_type_id = ?", params[:id], params[:locale] )
  end

  def index_tabulators
    if ['84','86'].include? (params[:id].to_s)
      @objs = Tabulator.where("service_type_id = ? AND specialty_id = ? AND subspecialty_id = ?", params[:id], params[:specialty_id].to_i, params[:subspecialty_id].to_i).distinct
      @objs = Adds::name_and_id(@objs)
      return render json: @objs, scope: {'locale': params[:locale]}
    elsif ['85'].include? (params[:id].to_s)
      @objs = Tabulator.where("service_type_id = ? AND specialty_id = ?", params[:id], params[:specialty_id].to_i).distinct
      @objs = Adds::name_and_id(@objs)
      return render json: @objs, scope: {'locale': params[:locale]}
    end
    render json: []
  end

  def search_services_records
    if (['111','112','113','114','115', '116'].include? (params[:record_id].to_s)) and (['87','89'].include? (params[:id].to_s))
      @objs = Tabulator.where("service_type_id = ?", params[:record_id]).distinct
    else
      return render json: []
    end
    @objs = Adds::name_and_id(@objs)
    render json: @objs, scope: {'locale': params[:locale]}
  end

  def search_providers
    if ['84', '85', '86'].include? (params[:id].to_s)
      @objs = UserAccess.joins(user_specialties: :user_tabs).where("user_tabs.tabulator_id = ? and is_active", params[:tabulator_id]).distinct
      @objs = @objs.joins(:user).where("users.city_id = ?", params[:city_id])
    elsif ['88'].include? (params[:id].to_s)
      @objs = UserAccess.joins(:user_specialties).where("user_specialties.specialty_id = ? and is_active", params[:specialty_id]).distinct
      @objs = @objs.joins(:user).where("users.city_id = ?", params[:city_id])
    else
      return render json: []
    end
    @objs = Adds::name_and_id(@objs)
    render json: @objs, each_serializer: UserAccessProviderServiceSerializer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tabulator
      @tabulator = Tabulator.find(params[:id])
    end

    def attributes_search(model, string, variable, locale=nil)
      @objs = model.where(string, variable)
      render json: @objs, scope: {'locale': locale}
    end

    # Only allow a trusted parameter "white list" through.
    def tabulator_params
      params.require(:tabulator).permit(:service_type_id, :specialty_id, :subspecialty_id, :suggested_price, :name, :description)
    end
end
