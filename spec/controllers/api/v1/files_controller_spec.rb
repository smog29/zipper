require 'rails_helper'

RSpec.shared_examples "not authorized" do
  let(:user_id) { -1 }

  it "returns an unauthorized error message" do
    request
    expect(response).to have_http_status(:unauthorized)
    expect(response_body).to include("errors" => "Unauthorized")
  end
end

RSpec.describe "Api::V1::FilesController", type: :request do
  describe "POST /api/v1/files" do
    let(:user) { create(:user) }
    let(:user_id) { user.id }
    let(:file) { fixture_file_upload(Rails.root.join("spec", "fixtures", "sample.txt"), "text/plain") }
    let(:headers) { { "Authorization" => "Bearer mock_token" } }

    before { allow(JWT).to receive(:decode).and_return([ { "user_id" => user_id } ]) }

    context "when user is not authorized" do
      it_behaves_like "not authorized" do
        let(:request) { post("/api/v1/files", params: { file: }, headers:) }
      end
    end

    context "when a file is uploaded successfully" do
      before do
        allow(FileManager::FileUploader).to receive(:call).and_return(
          double("FileUploader", success: true, download_link: "http://example.com/file.zip", password: "secure123")
        )
      end

      it "returns a download link and password" do
        post("/api/v1/files", params: { file: }, headers:)

        expect(response).to have_http_status(:ok)
        expect(response_body).to include(
          "download_link" => "http://example.com/file.zip",
          "password" => "secure123"
        )
      end
    end

    context "when no file is uploaded" do
      it "returns an error message" do
        post("/api/v1/files", params: {}, headers:)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to include("errors" => "No file uploaded")
      end
    end

    context "when file upload fails" do
      before do
        allow(FileManager::FileUploader).to receive(:call).and_return(
          double("FileUploader", success: false, errors: ["File upload failed"])
        )
      end

      it "returns an error message" do
        post("/api/v1/files", params: { file: }, headers:)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to include("errors" => ["File upload failed"])
      end
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end
