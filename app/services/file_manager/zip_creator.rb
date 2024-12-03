require "zip"

module FileManager
  class ZipCreator < ApplicationService
    def initialize(file_path)
      @file_path = file_path
      @password = SecureRandom.hex(4)
    end

    def call
      raise FileNotFoundError, "File not found at path: #{file_path}" unless File.exist?(file_path)

      file_name = File.basename(file_path)
      zip_name = File.basename(file_name, File.extname(file_name))
      zip_file_path = Rails.root.join("tmp", "#{zip_name}.zip")

      buffer = create_zip_buffer(file_name)

      File.open(zip_file_path, "wb") { |f| f.write(buffer.string) }

      { zip_file_path:, password: }
    end

    private

    attr_reader :file_path, :password

    def create_zip_buffer(file_name)
      Zip::OutputStream.write_buffer(::StringIO.new, Zip::TraditionalEncrypter.new(password)) do |out|
        out.put_next_entry(file_name)
        out.write File.read(file_path)
      end
    end
  end
end
