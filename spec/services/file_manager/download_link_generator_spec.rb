require 'rails_helper'

RSpec.describe FileManager::DownloadLinkGenerator, type: :service do
  let(:blob) { instance_double("ActiveStorage::Blob", signed_id: "abc123", filename: "test_file.txt") }
  let(:mock_url) { "http://example.com/rails/active_storage/blobs/abc123/test_file.txt" }

  before do
    allow(Rails.application.routes.url_helpers).to receive(:rails_blob_url)
      .with(blob, disposition: "attachment")
      .and_return(mock_url)
  end

  describe '#call' do
    subject(:download_link) { described_class.new(blob).call }

    it 'generates the mocked download link' do
      expect(download_link).to eq(mock_url)
    end

    it 'calls rails_blob_url with the correct arguments' do
      download_link
      expect(Rails.application.routes.url_helpers).to have_received(:rails_blob_url)
        .with(blob, disposition: "attachment")
    end
  end
end
