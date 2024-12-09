module FileManager
  module Results
    class FileListingResult
      attr_reader :success, :named_files, :errors

      def initialize(success:, named_files: nil, errors: nil)
        @success = success
        @named_files = named_files
        @errors = errors
      end
    end
  end
end
