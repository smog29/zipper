module FileManager
  class FileLister < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      Results::FileListingResult.new(success: true, named_files:)

      rescue StandardError => e
        Results::FileListingResult.new(success: false, errors: e.message)
    end

    private

    attr_reader :user

    def named_files
      named_files = user.files.map do |file|
        {
          name: file.blob.filename.to_s,
          download_link: DownloadLinkGenerator.call(file.blob)
        }
      end
    end
  end
end
