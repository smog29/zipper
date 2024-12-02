require "swagger_helper"

RSpec.describe "Files API" do
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:headers) { { "Authorization" => "Bearer mock_token" } }
  let(:Authorization) { "Bearer mock_token" }
  let(:params) { { file_path: } }
  let(:file_path) { "spec/fixtures/sample.txt" }

  before { allow(JWT).to receive(:decode).and_return([ { "user_id" => user_id } ]) }

  path "/api/v1/files" do
    post "Upload a file" do
      tags "Files"
      consumes "application/json"
      produces "application/json"
      security [ Bearer: [] ]

      parameter name: :params, in: :body, schema: { type: :object, properties: { file_path: { type: :string } } }, required: true, description: "The file to upload"

      response "200", "file uploaded successfully" do
        schema type: :object, properties: {
          download_link: { type: :string, example: "http://localhost:3000/files/sample.txt" },
          password: { type: :string, example: "password123" }
        }

        run_test!
      end

      response "422", "file upload failed" do
        let(:file_path) { nil }

        schema type: :object, properties: {
          errors: { type: :string, example: "File path not provided" }
        }

        run_test!
      end

      response "401", "unauthorized" do
        let(:user_id) { -1 }

        schema type: :object, properties: {
          errors: { type: :string, example: "Unauthorized request" }
        }

        run_test!
      end
    end

    get "List user files" do
      tags "Files"
      produces "application/json"
      security [ Bearer: [] ]

      response "200", "files listed successfully" do
        schema type: :object, properties: {
          files: {
            type: :array,
            items: {
              type: :object,
              properties: {
                name: { type: :string, example: "sample.txt" },
                download_link: { type: :string, example: "http://localhost:3000/files/sample.txt" }
              }
            }
          }
        }

        run_test!
      end

      response "401", "unauthorized" do
        let(:user_id) { -1 }

        schema type: :object, properties: {
          errors: { type: :string, example: "Unauthorized request" }
        }

        run_test!
      end
    end
  end
end
