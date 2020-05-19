class ShoppingListController < ApplicationController
  before_action :authorize_access_request!

  def send_mail
    begin
      ShoppingListMailer.shopping_list_mail(shopping_list_params[:shopping_list_email], shopping_list_params[:email_content]).deliver
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      render json: { error: "Unable to send email" }, status: :bad_request
    end
    render status: :ok
  end

  private

  # Only allow a trusted parameter "white list" through.
  def shopping_list_params
    params.permit(:email_content, :shopping_list_email)
  end
end