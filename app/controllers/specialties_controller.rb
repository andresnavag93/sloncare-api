class SpecialtiesController < ApplicationController
  before_action :request_12!, only: [:search_services_specialties]
  before_action :request_5!, only: [:create, :update]
  before_action :set_specialty, only: [:update]

  def create
    super(Specialty, specialty_params)
  end

  def update
    super(@specialty, specialty_params)
  end

  # GET /specialties
  def index
    objs = Specialty.where("specialty_id is ? and not provider", nil).order("name ASC")
    @objs = Adds::name_and_id(objs)
    render json: @objs, scope: {'locale': params[:locale] }
  end

  # GET /provider/specialties
  def index_provider
    objs = Specialty.where("specialty_id is ? and provider", nil).order("name ASC")
    @objs = Adds::name_and_id(objs)
    render json: @objs, scope: {'locale': params[:locale] }
  end

  # GET /doctors/specialties
  def index_doctor
    objs = Specialty.joins(:tabulators).where("specialties.specialty_id is ? AND tabulators.service_type_id in (?)", nil, [84 , 86]).distinct.order("name ASC")
    @objs = Adds::name_and_id(objs)
    render json: @objs, scope: {'locale': params[:locale] }
  end

  # GET /clinics/specialties
  def index_clinic
    objs = Specialty.joins(:tabulators).where("specialties.specialty_id is ? AND tabulators.service_type_id in (?) ", nil, [85]).distinct.order("name ASC")
    @objs = Adds::name_and_id(objs)
    render json: @objs, scope: {'locale': params[:locale] }
  end

  # GET /specialties/:id/subspecialties
  def subspecialties
    objs = Specialty.where("specialty_id = ?", params[:id]).order("name ASC")
    @objs = Adds::name_and_id(objs)
    render json: @objs, scope: {'locale': params[:locale] }
  end

  # GET /specialties
  def search_services_specialties
    if params[:id] == '88'
      objs = Specialty.joins(user_specialties: :user_access).where("specialties.specialty_id is ? AND access_id = ?", nil, 74).distinct.order("name ASC")
    elsif ['84','85','86'].include? (params[:id].to_s)
      objs = Specialty.joins(:tabulators).where("specialties.specialty_id is ? AND tabulators.service_type_id = ?", nil, params[:id]).distinct.order("name ASC")
    else
      objs = Specialty.where("specialty_id is ?", nil).distinct.order("name ASC")
    end
    @objs = Adds::name_and_id(objs)
    render json: objs, scope: {'locale': params[:locale] }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specialty
      @specialty = Specialty.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def specialty_params
      params.require(:specialty).permit(:specialty_id, :name, :name_en, :base, :provider)
    end
end
