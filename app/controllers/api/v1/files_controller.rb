module Api
  module V1
    class FilesController < ApplicationController
      before_action :validate_file_presence!, only: :create

      def index
        
      end

      def create
        file_uploader = FileManager::FileUploader.call(@current_user, params[:file])

        if file_uploader.success
          render json: { download_link: file_uploader.download_link, password: file_uploader.password }, status: :ok
        else
          render json: { errors: file_uploader.errors }, status: :unprocessable_entity
        end
      end

      private

      def validate_file_presence!
        if params[:file].blank?
          render json: { errors: "No file uploaded" }, status: :unprocessable_entity
        end
      end
    end
  end
end
