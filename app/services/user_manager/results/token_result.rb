module UserManager
  module Results
    class TokenResult
      attr_reader :success, :token, :errors

      def initialize(success:, token: nil, errors: nil)
        @success = success
        @token = token
        @errors = errors
      end
    end
  end
end
