module FileManager
  class DownloadLinkGenerator < ApplicationService
    def initialize(zip_file_path)
      @zip_file_path = zip_file_path
    end

    def call
      Rails.application.routes.url_helpers.rails_blob_path(@zip_file_path, only_path: true)
    end
  end
end
