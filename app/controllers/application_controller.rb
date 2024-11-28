class ApplicationController < ActionController::Base
  include JsonWebToken

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  protect_from_forgery with: :null_session

  before_action :authenticate_request!

  private

  def authenticate_request!
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    decoded = decode(header)
    @current_user = User.find(decoded[:user_id]) if decoded

    render json: { error: "Unauthorized" }, status: :unauthorized if @current_user.blank?
  end
end
