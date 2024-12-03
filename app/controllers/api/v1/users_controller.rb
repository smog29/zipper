module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request!, only: :create

      def create
        creator = UserManager::UserCreator.call(user_params)

        if creator.success
          render json: { token: creator.token }, status: :created
        else
          render json: { errors: creator.errors }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
