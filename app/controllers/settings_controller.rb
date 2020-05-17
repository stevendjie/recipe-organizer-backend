class SettingsController < ApplicationController
  before_action :authorize_access_request!

  def show
    render json: current_user, status: :ok
  end

  def update
    current_user.update(settings_params)
  end

  private

  # Only allow a trusted parameter "white list" through.
  def settings_params
    params.require(:settings).permit(:shopping_list_email)
  end
end    