module FileManager
  class FileAttacher < ApplicationService
    attr_reader :user, :file_path

    def initialize(user, file_path)
      @user = user
      @file_path = file_path
    end

    def call
      File.open(file_path).then do |file|
        blob = user.files.attach(io: file, filename: File.basename(file_path)).last
        cleanup_file
        blob
      end
    end

    private

    def cleanup_file
      File.delete(file_path) if File.exist?(file_path)
    end
  end
end
