module FileManager
  class FileUploader < ApplicationService
    def initialize(user, file_path)
      @user = user
      @file_path = file_path
    end

    def call
      zip_data = ZipCreator.call(file_path)
      file_blob = FileAttacher.call(user, zip_data[:zip_file_path])
      download_link = DownloadLinkGenerator.call(file_blob)

      Results::FileUploadResult.new(success: true, download_link:, password: zip_data[:password])

      rescue FileNotFoundError, StandardError => e
        Results::FileUploadResult.new(success: false, errors: e.message)
    end

    private

    attr_reader :user, :file_path
  end
end
