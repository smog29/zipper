module FileManager
  class FileAttacher < ApplicationService
    attr_reader :user, :file_path

    def initialize(user, file_path)
      @user = user
      @file_path = file_path
    end

    def call
      io = File.open(file_path)
      blob = user.files.attach(io:, filename: File.basename(file_path)).last
      io.close
      cleanup_file
      blob
    end

    private

    def cleanup_file
      File.delete(file_path) if File.exist?(file_path)
    end
  end
end
