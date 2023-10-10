class NotificationsController < ApplicationController
  before_action :request_all!, only: [:index]
  before_action :request_7!, only: [:create, :show]  
  before_action :set_notification, only: [:destroy]

  def index
    @offset = params[:init].to_i
    @limit = params[:end].to_i - @offset + 1
    if @current_user and [69, 70, 71, 72, 74].include? @current_user.access_id
      @objs = Notification.where("access_id = ?", @current_user.access_id).order("created_at DESC").offset(@offset).limit(@limit)
    else
      @objs = Notification.order("id DESC").offset(@offset).limit(@limit)
    end
    render json: @objs, scope: {'locale': params[:locale] }
  end

  def create
    super(Notification, notification_params)
  end

  def destroy
    super(@notification)
  end
  
  def health
    render json: true
  end

  def ssl
    render json: ENV["SSL_CERTIFICATE"]
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def notification_params
      params.require(:notification).permit(:title, :description, :access_id)
    end
end
