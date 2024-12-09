module UserManager
  class UserLogin < ApplicationService
    include JsonWebToken

    def initialize(email, password)
      @email = email
      @password = password
    end

    def call
      user = User.find_by(email: @email)

      if user&.authenticate(@password)
        token = encode(user_id: user.id)

        Results::TokenResult.new(success: true, token: token)
      else
        Results::TokenResult.new(success: false, errors: "Invalid email or password")
      end
    end
  end
end
