module Api
  module V1
    class FileUploadsController < ApplicationController
      def create
        file = params[:file]

        if file.blank?
          render json: { error: "No file uploaded" }, status: :unprocessable_entity
          return
        end

        file_uploader = FileManager::FileUploader.call(@current_user, file)

        render json: { download_link: file_uploader[:download_link], password: file_uploader[:password] }, status: :ok
      # rescue StandardError => e
      #   render json: { error: "Something went wrong: #{e.message}" }, status: :internal_server_error
      end
    end
  end
end
