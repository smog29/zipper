require 'rails_helper'

RSpec.describe "Authentication managment", type: :request do
  let(:user) { create(:user, password: "SecurePass1!", password_confirmation: "SecurePass1!") }
  let(:valid_credentials) do
    {
      email: user.email,
      password: "SecurePass1!"
    }
  end
  let(:invalid_credentials) do
    {
      email: user.email,
      password: "WrongPass!"
    }
  end

  describe "POST /api/v1/auth/login" do
    let(:json_response) { JSON.parse(response.body) }

    context "when credentials are valid" do
      it "returns a token" do
        post("/api/v1/auth/login", params: valid_credentials, as: :json)

        expect(response).to have_http_status(:ok)
        expect(json_response).to include("token")
      end
    end

    context "when credentials are invalid" do
      it "returns an error message" do
        post("/api/v1/auth/login", params: invalid_credentials, as: :json)

        expect(response).to have_http_status(:unauthorized)
        expect(json_response).to include("errors")
        expect(json_response["errors"]).to include("Invalid email or password")
      end
    end

    context "when email is missing" do
      it "returns an error message" do
        post("/api/v1/auth/login", params: { password: "SecurePass1!" }, as: :json)

        expect(response).to have_http_status(:unauthorized)
        expect(json_response).to include("errors")
        expect(json_response["errors"]).to include("Invalid email or password")
      end
    end

    context "when password is missing" do
      it "returns an error message" do
        post("/api/v1/auth/login", params: { email: user.email }, as: :json)

        expect(response).to have_http_status(:unauthorized)
        expect(json_response).to include("errors")
        expect(json_response["errors"]).to include("Invalid email or password")
      end
    end
  end
end
