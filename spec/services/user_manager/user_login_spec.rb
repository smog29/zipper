require 'rails_helper'

RSpec.describe UserManager::UserLogin, type: :service do
  let(:user) { create(:user, password: valid_password, password_confirmation: valid_password) }
  let(:valid_email) { user.email }
  let(:valid_password) { "SecurePass1!" }
  let(:invalid_email) { "wrong@example.com" }
  let(:invalid_password) { "WrongPass!" }

  describe '#call' do
    context 'when credentials are valid' do
      it 'returns a token and the user' do
        service = UserManager::UserLogin.new(valid_email, valid_password)
        result = service.call

        expect(result[:token]).to be_present
        expect(result[:errors]).to be_empty
      end
    end

    context 'when email is invalid' do
      it 'returns an error message' do
        service = UserManager::UserLogin.new(invalid_email, valid_password)
        result = service.call

        expect(result[:token]).to be_nil
        expect(result[:errors]).to eq("Invalid email or password")
      end
    end

    context 'when password is invalid' do
      it 'returns an error message' do
        service = UserManager::UserLogin.new(valid_email, invalid_password)
        result = service.call

        expect(result[:token]).to be_nil
        expect(result[:errors]).to eq("Invalid email or password")
      end
    end

    context 'when both email and password are invalid' do
      it 'returns an error message' do
        service = UserManager::UserLogin.new(invalid_email, invalid_password)
        result = service.call

        expect(result[:token]).to be_nil
        expect(result[:errors]).to eq("Invalid email or password")
      end
    end
  end
end