class UserTabsController < ApplicationController
  before_action :request_346!, only: [:index_user, :update, :provider_index_user]
  before_action only: [:index_user, :update, :provider_index_user] do  
    verify_correct_path_id(params[:user_id].to_i, [@current_user.id]) 
  end
  before_action :set_user, only: [:index_user, :update, :provider_index_user]

  def index_user
    begin
      if ['84','86'].include? (params[:service_type_id].to_s)
        if @user.access_id == 70
          @objs = Tabulator.joins(user_tabs: {user_specialty: :user_access}).where(
            "user_accesses.id = ? AND user_specialties.specialty_id = ? AND user_specialties.subspecialty_id = ? AND tabulators.service_type_id = ? ", 
            params[:user_id], params[:specialty_id].to_i, params[:subspecialty_id].to_i, params[:service_type_id]).distinct 
          @objs = Adds::name_and_id(@objs)
          return render json: @objs 
        end
      elsif ['85'].include? (params[:service_type_id].to_s)
        if @user.access_id == 71 
          @objs = Tabulator.joins(user_tabs: {user_specialty: :user_access}).where(
            "user_accesses.id = ? AND user_specialties.specialty_id = ? AND tabulators.service_type_id = ? ", 
            params[:user_id], params[:specialty_id].to_i, params[:service_type_id]).distinct 
          @objs = Adds::name_and_id(@objs)
          return render json: @objs 
        end
      end
      render json: []
    rescue 
     render json: []
    end
  end

  def provider_index_user
    begin
      if ['84','86'].include? (params[:service_type_id].to_s)
        if @user.access_id == 70
          @objs_all = Tabulator.where("service_type_id = ? AND specialty_id = ? AND subspecialty_id = ?", 
            params[:service_type_id], params[:specialty_id].to_i, params[:subspecialty_id].to_i).distinct
          @objs = Tabulator.joins(user_tabs: {user_specialty: :user_access}).where(
            "user_accesses.id = ? AND user_specialties.specialty_id = ? AND user_specialties.subspecialty_id = ? AND tabulators.service_type_id = ? ", 
            params[:user_id], params[:specialty_id].to_i, params[:subspecialty_id].to_i, params[:service_type_id]).distinct 
          @objs_all = Adds::name_and_id(@objs_all)
          @objs_no = @objs_all - @objs
          @objs_yes = @objs_all - @objs_no
          return render json: Search.new(@objs_yes, @objs_no)
        end
      elsif ['85'].include? (params[:service_type_id].to_s)
        if @user.access_id == 71 
          @objs_all = Tabulator.where("service_type_id = ? AND specialty_id = ?", 
            params[:service_type_id], params[:specialty_id].to_i).distinct
          @objs = Tabulator.joins(user_tabs: {user_specialty: :user_access}).where(
            "user_accesses.id = ? AND user_specialties.specialty_id = ? AND tabulators.service_type_id = ? ", 
            params[:user_id], params[:specialty_id].to_i, params[:service_type_id]).distinct 
          @objs_all = Adds::name_and_id(@objs_all)
          @objs_no = @objs_all - @objs
          @objs_yes = @objs_all - @objs_no
          return render json: Search.new(@objs_yes, @objs_no)
        end
      end
      render json: []
    rescue 
     render json: []
    end
  end

  def find_tab_in_list(list, obj)
    for tab in list
      if obj[:id] == tab[:tabulator_id]
        return tab
      end
    end
    return nil
  end

  def update
    begin
      if ['84','86'].include? (params[:service_type_id].to_s)
        if @user.access_id == 70
          @user_specialty = @user.user_specialties.find_by(specialty_id: params[:specialty_id].to_i, subspecialty_id: params[:subspecialty_id].to_i)
          if @user_specialty
            aux = UserTab.joins(:tabulator, user_specialty: :user_access).where(
              "user_accesses.id = ? AND 
              user_specialties.specialty_id = ? AND 
              user_specialties.subspecialty_id = ? AND 
              tabulators.service_type_id = ? ", 
              @user.id, params[:specialty_id].to_i, params[:subspecialty_id].to_i, params[:service_type_id].to_i).distinct 
            params[:yes].each do |tab|
              user_tab = find_tab_in_list(aux, tab)
              if !user_tab
                @tabulator = Tabulator.find_by(id: tab[:id], service_type_id: params[:service_type_id])
                if @tabulator 
                  if (@tabulator.specialty_id == params[:specialty_id].to_i) and (@tabulator.subspecialty_id == params[:subspecialty_id].to_i)
                    UserTab.new({user_specialty: @user_specialty, tabulator: @tabulator}).save
                  end
                end
              else
                aux = aux - [user_tab]
              end
            end
            aux.each do |tab|
              tab.destroy
            end
            return render json: {success: 1}, status: :created
          end
        end

      elsif ['85'].include? (params[:service_type_id].to_s)
        if @user.access_id == 71
          @user_specialty = @user.user_specialties.find_by(specialty_id: params[:specialty_id].to_i, subspecialty_id: nil)
          if @user_specialty
            aux = UserTab.joins(:tabulator, user_specialty: :user_access).where(
              "user_accesses.id = ? AND 
              user_specialties.specialty_id = ? AND 
              tabulators.service_type_id = ? ", 
              @user.id, params[:specialty_id].to_i, params[:service_type_id]).distinct 
            params[:yes].each do |tab|
              user_tab = find_tab_in_list(aux, tab)
              if !user_tab
                @tabulator = Tabulator.find_by(id: tab[:id], service_type_id: params[:service_type_id])
                if @tabulator 
                  if (@tabulator.specialty_id == params[:specialty_id].to_i)
                    UserTab.new({user_specialty: @user_specialty, tabulator: @tabulator}).save
                  end
                end
              else
                aux = aux - [user_tab]
              end
            end
            aux.each do |tab|
              tab.destroy
            end
            return render json: {success: 1}, status: :created
          end
        end
      end
      render json: {errors: [Errors::translate(92)]}, status: :unprocessable_entity
    rescue 
      render json: {errors: [Errors::translate(92)]}, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = @current_user
      #@user = UserAccess.find(params[:user_id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_tab_params
      params.require(:user_tab).permit(:user_specialty_id, :tabulator_id)
    end
end
