require "swagger_helper"

RSpec.describe "Authentication API" do
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
  let(:Authorization) { nil }

  path "/api/v1/auth/login" do
    post "Login with email and password" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: "string" },
          password: { type: :string, example: "string" }
        },
        required: [ "email", "password" ]
      }, description: "Authenticate user with email and password"

      response "200", "login successful" do
        schema type: :object, properties: {
          token: { type: :string, example: "jwt_token" }
        }

        let(:params) { valid_credentials }

        run_test!
      end

      response "401", "unauthorized" do
        schema type: :object, properties: {
          errors: { type: :string, example: "Invalid email or password" }
        }

        let(:params) { invalid_credentials }

        run_test!
      end
    end
  end
end
