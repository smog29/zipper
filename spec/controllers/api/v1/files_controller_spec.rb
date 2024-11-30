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
    let(:file_path) { fixture_file_upload(Rails.root.join("spec", "fixtures", "sample.txt"), "text/plain") }
    let(:headers) { { "Authorization" => "Bearer mock_token" } }

    before { allow(JWT).to receive(:decode).and_return([ { "user_id" => user_id } ]) }

    context "when user is not authorized" do
      it_behaves_like "not authorized" do
        let(:request) { post("/api/v1/files", params: { file_path: }, headers:) }
      end
    end

    context "when a file is uploaded successfully" do
      before do
        allow(FileManager::FileUploader).to receive(:call).and_return(
          double("FileUploader", success: true, download_link: "http://example.com/file.zip", password: "secure123")
        )
      end

      it "returns a download link and password" do
        post("/api/v1/files", params: { file_path: }, headers:)

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
          double("FileUploader", success: false, errors: [ "File upload failed" ])
        )
      end

      it "returns an error message" do
        post("/api/v1/files", params: { file_path: }, headers:)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to include("errors" => [ "File upload failed" ])
      end
    end
  end

  describe "GET /api/v1/files" do
    let(:user) { create(:user) }
    let(:user_id) { user.id }
    let(:headers) { { "Authorization" => "Bearer mock_token" } }

    before { allow(JWT).to receive(:decode).and_return([ { "user_id" => user_id } ]) }

    context "when user is not authorized" do
      it_behaves_like "not authorized" do
        let(:request) { get("/api/v1/files", headers:) }
      end
    end

    context "when the user has files" do
      let(:file1) { 'file1.txt' }
      let(:file2) { 'file2.txt' }

      before do
        allow(FileManager::FileLister).to receive(:call).and_return(
          double("FileLister", success: true, named_files: [
            { name: file1, download_link: "http://example.com/#{file1}" },
            { name: file2, download_link: "http://example.com/#{file2}" }
          ])
        )
      end

      it "returns a list of files with download links" do
        get("/api/v1/files", headers:)

        expect(response).to have_http_status(:ok)
        expect(response_body).to include(
          "files" => [
            { "name" => file1, "download_link" => "http://example.com/#{file1}" },
            { "name" => file2, "download_link" => "http://example.com/#{file2}" }
          ]
        )
      end
    end

    context "when the user has no files" do
      it "returns an empty list" do
        get("/api/v1/files", headers:)

        expect(response).to have_http_status(:ok)
        expect(response_body).to include("files" => [])
      end
    end

    context "when an error occurs while fetching files" do
      before do
        allow(FileManager::FileLister).to receive(:call).and_return(
          double("FileLister", success: false, errors: "Unable to fetch files")
        )
      end

      it "returns an error message" do
        get("/api/v1/files", headers:)

        expect(response).to have_http_status(:internal_server_error)
        expect(response_body).to include("errors" => "Unable to fetch files")
      end
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end
