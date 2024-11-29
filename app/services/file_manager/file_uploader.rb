module FileManager
  class FileUploader < ApplicationService
    attr_reader :user, :file_path

    def initialize(user, file_path)
      @user = user
      @file_path = file_path
    end

    def call
      zip_file_path = ZipCreator.call(file_path)
      file_blob = FileAttacher.call(user, zip_file_path) { cleanup_zip_file(zip_file_path) }
      download_link = DownloadLinkGenerator.call(file_blob)

      { download_link:, password: "123" }
    end

    private

    def cleanup_zip_file(zip_file_path)
      File.delete(zip_file_path) if File.exist?(zip_file_path)
    end
  end
end
