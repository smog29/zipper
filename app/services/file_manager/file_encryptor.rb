module FileManager
  class FileEncryptor < ApplicationService
    def initialize(file_path, password)
      @file_path = file_path
      @password = password
    end

    def call
      encrypted_file_path = Rails.root.join("tmp", "#{SecureRandom.hex}.enc")
      cipher = OpenSSL::Cipher.new("aes-256-cbc")
      cipher.encrypt
      cipher.key = @password
      iv = cipher.random_iv
      cipher.iv = iv

      # Directly open the file using the provided file path
      File.open(encrypted_file_path, "wb") do |out_file|
        File.open(@file_path, "rb") do |in_file|
          out_file.write(iv)
          IO.copy_stream(in_file, out_file)
        end
      end

      encrypted_file_path
    end
  end
end
