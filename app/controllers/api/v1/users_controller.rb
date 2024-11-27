module Api
  module V1
    class UsersController < ApplicationController
      # Post /users
      def create
        creator = UserManager::UserCreator.call(user_params)

        render json: creator, status: creator[:errors].blank? ? :created : :unprocessable_entity
      end

      private

      def user_params
        {
          name: params[:name],
          email: params[:email],
          password: params[:password],
          password_confirmation: params[:password_confirmation]
        }
      end
    end
  end
end
