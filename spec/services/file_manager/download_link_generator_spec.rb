require 'rails_helper'

RSpec.describe FileManager::DownloadLinkGenerator, type: :service do
  let(:zip_file_path) { Rails.root.join("tmp", "#{SecureRandom.hex}.zip") }
  let(:download_link) { described_class.call(zip_file_path) }

  before do
    allow(Rails.application.routes.url_helpers).to receive(:rails_blob_path)
      .with(zip_file_path, only_path: true)
      .and_return("/download/#{zip_file_path.basename}")
  end

  describe '#call' do
    it 'generates a download link for the zip file' do
      expect(download_link).to eq("/download/#{zip_file_path.basename}")
    end
  end
end
