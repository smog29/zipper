module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request!, only: :login

      def login
        login_service = UserManager::UserLogin.call(params[:email], params[:password])

        if login_service.success
          render json: { token: login_service.token }, status: :ok
        else
          render json: { errors: login_service.errors }, status: :unauthorized
        end
      end
    end
  end
end
