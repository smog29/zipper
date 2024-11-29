module FileManager
  class FileUploader < ApplicationService
    attr_reader :user, :file_path

    def initialize(user, file_path)
      @user = user
      @file_path = file_path
    end

    def call
      zip_file_path = ZipCreator.call(file_path)
      file_blob = FileAttacher.call(user, zip_file_path)
      download_link = DownloadLinkGenerator.call(file_blob)

      FileUploadResult.new(success: true, download_link: download_link, password: "123")

      rescue FileNotFoundError, StandardError => e
        FileUploadResult.new(success: false, errors: e.message)
    end
  end
end
