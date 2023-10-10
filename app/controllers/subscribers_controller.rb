class SubscribersController < ApplicationController

  # POST /subscribers
  def create
    super(Subscriber, subscriber_params)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscriber
      @subscriber = Subscriber.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def subscriber_params
      params.require(:subscriber).permit(:email)
    end
end
