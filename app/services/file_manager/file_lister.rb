module FileManager
  class FileLister < ApplicationService
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      named_files = user.files.map do |file|
        {
          name: file.blob.filename.to_s,
          download_link: DownloadLinkGenerator.call(file.blob)
        }
      end

      Results::FileListingResult.new(success: true, named_files:)

      rescue StandardError => e
        Results::FileListingResult.new(success: false, errors: e.message)
    end
  end
end
