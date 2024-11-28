module FileManager
  class Zipper < ApplicationService
    def initialize(encrypted_file_path)
      @encrypted_file_path = encrypted_file_path
    end

    def call
      zip_file_path = Rails.root.join("tmp", "#{SecureRandom.hex}.zip")

      Zip::File.open(zip_file_path, Zip::File::CREATE) do |zipfile|
        zipfile.add("encrypted_file.enc", @encrypted_file_path)
      end

      File.delete(@encrypted_file_path) if File.exist?(@encrypted_file_path)
      zip_file_path
    end
  end
end
