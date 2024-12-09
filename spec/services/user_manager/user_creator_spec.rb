require 'rails_helper'

RSpec.describe UserManager::UserCreator, type: :service do
  let(:valid_params) do
    {
      name: "John Doe",
      email: "user@example.com",
      password: "SecurePass1!",
      password_confirmation: "SecurePass1!"
    }
  end

  let(:invalid_params) do
    {
      name: "",
      email: "invalid_email",
      password: "short",
      password_confirmation: "short"
    }
  end

  describe '#call' do
    context 'when user creation is successful' do
      it 'returns a token' do
        result = UserManager::UserCreator.call(valid_params)

        expect(result.token).to be_present
        expect(result.errors).to be_nil
        expect(User.find_by(email: valid_params[:email])).to be_present
      end
    end

    context 'when user creation fails due to validation errors' do
      it 'returns an error message' do
        result = UserManager::UserCreator.call(invalid_params)

        expect(result.token).to be_nil
        expect(result.errors).to be_present
        expect(result.errors).to include("Name can't be blank")
        expect(result.errors).to include("Email is invalid")
        expect(result.errors).to include("Password is too short")
        expect(User.find_by(email: invalid_params[:email])).to be_nil
      end
    end
  end
end
