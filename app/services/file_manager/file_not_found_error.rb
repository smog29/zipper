module FileManager
  class FileNotFoundError < StandardError
    def initialize(msg = "File not found")
      super
    end
  end
end
