module FileManager
  class FileUploadResult
    attr_reader :success, :download_link, :password, :errors

    def initialize(success:, download_link: nil, password: nil, errors: nil)
      @success = success
      @download_link = download_link
      @password = password
      @errors = errors
    end
  end
end
