require 'rails_helper'
require 'zip'

RSpec.describe FileManager::Zipper, type: :service do
  let(:encrypted_file_path) { Rails.root.join("tmp", "encrypted_file.enc") }
  let(:zip_file_path) { Rails.root.join("tmp", "#{SecureRandom.hex}.zip") }

  before do
    File.open(encrypted_file_path, "wb") { |f| f.write("dummy encrypted content") }
  end

  after do
    # Clean up the files after the test
    File.delete(encrypted_file_path) if File.exist?(encrypted_file_path)
    File.delete(zip_file_path) if File.exist?(zip_file_path)
  end

  describe '#call' do
    subject(:zip_path) { described_class.call(encrypted_file_path) }

    it 'creates a zip file containing the encrypted file' do
      expect(File).to exist(zip_path)

      # Check if the encrypted file is added inside the zip
      Zip::File.open(zip_path) do |zipfile|
        expect(zipfile.find_entry('encrypted_file.enc')).not_to be_nil
      end
    end

    context 'when the original encrypted file is not yet deleted' do
      subject(:zipper) { described_class.new(encrypted_file_path) }

      it 'removes the original encrypted file after zipping' do
        # Ensure the encrypted file exists before calling the service
        expect(File.exist?(encrypted_file_path)).to be true

        subject.call

        # Ensure the encrypted file is deleted
        expect(File.exist?(encrypted_file_path)).to be false
      end
    end

    it 'creates a zip file with the .zip extension' do
      expect(zip_path.to_s).to end_with('.zip')
    end
  end
end
