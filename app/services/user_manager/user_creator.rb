module UserManager
  class UserCreator < ApplicationService
    include JsonWebToken

    def initialize(user_params)
      @user_params = user_params
    end

    def call
      user = User.new(@user_params)

      if user.save
        token = encode(user_id: user.id)
        Results::TokenResult.new(success: true, token:)
      else
        Results::TokenResult.new(success: false, errors: user.errors.full_messages.to_sentence)
      end
    end
  end
end
