module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request!

      # Post /login
      def login
        login_service = UserManager::UserLogin.call(params[:email], params[:password])

        render json: login_service, status: login_service[:errors].blank? ? :ok : :unauthorized
      end
    end
  end
end
