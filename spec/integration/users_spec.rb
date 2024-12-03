require "swagger_helper"

RSpec.describe "Users Management API" do
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
  let(:Authorization) { nil }

  path "/api/v1/users" do
    post "Create a user" do
      tags "Users"
      consumes "application/json"
      produces "application/json"

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "string" },
          email: { type: :string, example: "string" },
          password: { type: :string, example: "string" },
          password_confirmation: { type: :string, example: "string" }
        },
        required: [ "name", "email", "password", "password_confirmation" ]
      }, description: "Create a new user"

      response "201", "user created successfully" do
        schema type: :object, properties: {
          token: { type: :string, example: "jwt_token" }
        }

        let(:params) { valid_params }

        run_test!
      end

      response "422", "unprocessable entity" do
        schema type: :object, properties: {
          errors: {
            type: :string,
            example: "Password confirmation doesn't match Password, Name can't be blank, Email is invalid, " \
                     "Password is too short (minimum is 6 characters), " \
                     "and Password Must include at least one uppercase letter and one special character"
          }
        }

        let(:params) { invalid_params }

        run_test!
      end
    end
  end
end
