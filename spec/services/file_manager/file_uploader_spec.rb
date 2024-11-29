require 'rails_helper'
require 'zip'

RSpec.describe FileManager::FileUploader, type: :service do
  let(:user) { create(:user) }
  let(:file_name) { "test_file" }
  let(:file_path) { Rails.root.join("tmp", "#{file_name}.txt") }
  let(:zip_file_path) { Rails.root.join("tmp", "#{file_name}.zip") }
  let(:link) { "www.example.com/link" }

  describe '#call' do
    subject(:download_link) { described_class.call(user, file_path) }

    before do
      fake_blob = instance_double(ActiveStorage::Blob)
      allow(FileManager::ZipCreator).to receive(:call).with(file_path).and_return(zip_file_path)
      allow(FileManager::FileAttacher).to receive(:call).with(user, zip_file_path).and_return(fake_blob)
      allow(FileManager::DownloadLinkGenerator).to receive(:call).with(fake_blob).and_return(link)
    end

    it 'calls the stubbed services' do
      expect(download_link.success).to be true
      expect(download_link.download_link).to eq(link)
      expect(download_link.password).to eq("123")
      expect(download_link.errors).to be_nil
    end

    context 'when FileNotFoundError is raised' do
      before do
        allow(FileManager::ZipCreator).to receive(:call).and_raise(FileManager::FileNotFoundError)
      end

      it 'returns a failed result' do
        expect(download_link.success).to be false
        expect(download_link.download_link).to be_nil
        expect(download_link.password).to be_nil
        expect(download_link.errors).to eq("File not found")
      end
    end
  end
end
