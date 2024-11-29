module FileManager
  class FileAttacher < ApplicationService
    attr_reader :user, :file_path

    def initialize(user, file_path)
      @user = user
      @file_path = file_path
    end

    def call
      io = File.open(file_path)
      blob = user.files.attach(io:, filename: File.basename(file_path)).first
      io.close
      yield(file_path) if block_given?
      blob
    end
  end
end
