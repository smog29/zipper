require 'rails_helper'

RSpec.describe FileManager::FileLister, type: :service do
  let(:user) { create(:user) }

  let(:blob1) { instance_double(ActiveStorage::Blob, filename: "file1.txt") }
  let(:blob2) { instance_double(ActiveStorage::Blob, filename: "file2.txt") }

  let(:file1) { instance_double(ActiveStorage::Attachment, blob: blob1) }
  let(:file2) { instance_double(ActiveStorage::Attachment, blob: blob2) }

  let(:files) { [ file1, file2 ] }

  before do
    allow(user).to receive(:files).and_return(files)
    allow(FileManager::DownloadLinkGenerator).to receive(:call).with(blob1).and_return("http://example.com/file1.txt")
    allow(FileManager::DownloadLinkGenerator).to receive(:call).with(blob2).and_return("http://example.com/file2.txt")
  end

  describe '#call' do
    subject(:listed_files) { described_class.call(user) }

    context 'when the user has files' do
      it 'returns a success result with a list of files and download links' do
        expect(listed_files.success).to be true
        expect(listed_files.named_files).to contain_exactly(
          { name: 'file1.txt', download_link: 'http://example.com/file1.txt' },
          { name: 'file2.txt', download_link: 'http://example.com/file2.txt' }
        )
      end
    end

    context 'when an error occurs' do
      before do
        allow(user).to receive(:files).and_raise(StandardError, "Unexpected error")
      end

      it 'returns a failure result with the error message' do
        expect(listed_files.success).to be false
        expect(listed_files.errors).to eq("Unexpected error")
      end
    end
  end
end
