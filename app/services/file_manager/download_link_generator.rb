module FileManager
  class DownloadLinkGenerator < ApplicationService
    def initialize(user, zip_file_path)
      @user = user
      @zip_file_path = zip_file_path
    end

    def call
      # Attach the file to the user's ActiveStorage and return the URL
      blob = attach_file
      Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
    end

    private

    def attach_file
      # Open the file at the given path and attach it to the user's ActiveStorage files
      io = File.open(@zip_file_path)
      blob = @user.files.attach(io: io, filename: File.basename(@zip_file_path)).first # Attach and get the first (only) blob
      io.close
      blob
    end
  end
end
