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
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
