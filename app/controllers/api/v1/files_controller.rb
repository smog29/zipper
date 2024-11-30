module Api
  module V1
    class FilesController < ApplicationController
      before_action :validate_file_presence!, only: :create

      def index
        file_lister = FileManager::FileLister.call(@current_user)

        if file_lister.success
          render json: { files: file_lister.named_files }, status: :ok
        else
          render json: { errors: file_lister.errors }, status: :internal_server_error
        end
      end

      def create
        file_uploader = FileManager::FileUploader.call(@current_user, params[:file_path])

        if file_uploader.success
          render json: { download_link: file_uploader.download_link, password: file_uploader.password }, status: :ok
        else
          render json: { errors: file_uploader.errors }, status: :unprocessable_entity
        end
      end

      private

      def validate_file_presence!
        if params[:file_path].blank?
          render json: { errors: "No file uploaded" }, status: :unprocessable_entity
        end
      end
    end
  end
end
