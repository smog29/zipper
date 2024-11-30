class ApplicationController < ActionController::Base
  include JsonWebToken

  protect_from_forgery with: :null_session

  before_action :authenticate_request!

  private

  def authenticate_request!
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    decoded = decode(header)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded

    render json: { errors: "Unauthorized" }, status: :unauthorized if @current_user.blank?
  end
end
