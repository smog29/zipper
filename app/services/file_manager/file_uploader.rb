module FileManager
  class FileUploader < ApplicationService
    def initialize(user, file)
      @user = user
      @file = file
    end

    def call
      password = SecureRandom.hex(16)
      encrypted_file_path = encrypt_file(password)
      zip_file_path = create_zip(encrypted_file_path)
      download_link = generate_download_link(zip_file_path)

      { download_link:, password: }
    end

    private

    def encrypt_file(password)
      FileEncryptor.call(@file, password)
    end

    def create_zip(encrypted_file_path)
      Zipper.call(encrypted_file_path)
    end

    def generate_download_link(zip_file_path)
      DownloadLinkGenerator.call(@user, zip_file_path)
    end
  end
end
