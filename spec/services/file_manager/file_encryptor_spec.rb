require 'rails_helper'

RSpec.describe FileManager::FileEncryptor, type: :service do
  let(:user) { create(:user) }
  let(:file) { fixture_file_upload('spec/fixtures/sample.txt', 'text/plain') }
  let(:password) { SecureRandom.hex(16) }

  describe '#call' do
    subject { described_class.call(file, password) }

    it 'creates an encrypted file' do
      encrypted_file_path = subject
      expect(File.exist?(encrypted_file_path)).to be_truthy
    end

    it 'creates a file with .enc extension' do
      encrypted_file_path = subject
      expect(encrypted_file_path.to_s).to end_with('.enc')
    end

    it 'encrypts the file (i.e., it is different from the original)' do
      original_file_content = File.read(file.path)
      encrypted_file_path = subject
      encrypted_file_content = File.read(encrypted_file_path)

      expect(original_file_content).not_to eq(encrypted_file_content)
    end

    it 'includes the IV at the beginning of the encrypted file' do
      encrypted_file_path = subject
      encrypted_data = File.read(encrypted_file_path)

      # Checking if the IV is prepended at the start of the file
      iv_length = OpenSSL::Cipher.new("aes-256-cbc").iv_len
      expect(encrypted_data[0, iv_length]).to eq(File.read(encrypted_file_path)[0, iv_length])
    end
  end
end
