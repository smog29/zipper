require 'rails_helper'

RSpec.describe FileManager::FileUploader, type: :service do
  let(:user) { create(:user) }
  let(:file) { fixture_file_upload('spec/fixtures/sample.txt', 'text/plain') }
  let(:file_uploader) { described_class.new(user, file) }
  let(:password) { '35c170c58c136579bbcfce59364627d9' }
  let(:encrypted_file_path) { Rails.root.join("tmp", "#{SecureRandom.hex}.enc") }
  let(:zip_file_path) { Rails.root.join("tmp", "#{SecureRandom.hex}.zip") }

  describe '#call' do
    before do
      allow(SecureRandom).to receive(:hex).and_return(password)
      allow(FileManager::FileEncryptor).to receive(:call).with(file, password).and_return(encrypted_file_path)
      allow(FileManager::Zipper).to receive(:call).with(encrypted_file_path).and_return(zip_file_path)
      allow(FileManager::DownloadLinkGenerator)
        .to receive(:call)
        .with(zip_file_path)
        .and_return("/download/#{zip_file_path.basename}")
    end

    it 'returns a download link and a password' do
      result = file_uploader.call

      expect(result).to include(:download_link)
      expect(result[:download_link]).to eq("/download/#{zip_file_path.basename}")
      expect(result).to include(:password)
      expect(result[:password].length).to eq(32) # ensure the key is 32 bytes
    end

    it 'calls FileEncryptor with the correct arguments' do
      expect(FileManager::FileEncryptor).to receive(:call).with(file, password)
      file_uploader.call
    end

    it 'calls Zipper with the encrypted file path' do
      expect(FileManager::Zipper).to receive(:call).with(encrypted_file_path)
      file_uploader.call
    end

    it 'calls DownloadLinkGenerator with the zip file path' do
      expect(FileManager::DownloadLinkGenerator).to receive(:call).with(zip_file_path)
      file_uploader.call
    end
  end
end
