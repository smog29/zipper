require "zip"

module FileManager
  class ZipCreator < ApplicationService
    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def call
      file_name = File.basename(file_path)
      zip_name = File.basename(file_name, File.extname(file_name))
      zip_file_path = Rails.root.join("tmp", "#{zip_name}.zip")

      # Override the existing zip file if it already exists
      File.delete(zip_file_path) if File.exist?(zip_file_path)

      Zip::File.open(zip_file_path, Zip::File::CREATE) do |zipfile|
        zipfile.add(file_name, file_path)
      end

      zip_file_path
    end
  end
end
