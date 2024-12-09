require 'rails_helper'

RSpec.describe "Users managment", type: :request do
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
      password_confirmation: "mismatch"
    }
  end

  describe "POST /api/v1/users" do
    let(:json_response) { JSON.parse(response.body) }

    context "when the request is valid" do
      it "creates a new user and returns a token" do
        post("/api/v1/users", params: valid_params, as: :json)

        expect(response).to have_http_status(:created)
        expect(json_response).to include("token")
      end
    end

    context "when the request is invalid" do
      it "does not create a user and returns an error message" do
        post("/api/v1/users", params: invalid_params, as: :json)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to include("errors")
        expect(json_response["errors"]).to include("Name can't be blank")
      end
    end
  end
end
