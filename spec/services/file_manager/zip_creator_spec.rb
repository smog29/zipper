require 'rails_helper'
require 'zip'

RSpec.describe FileManager::ZipCreator, type: :service do
  let(:file_name) { "text_file" }
  let(:file_path) { Rails.root.join("tmp", "#{file_name}.txt") }
  let(:zip_file_path) { Rails.root.join("tmp", "#{file_name}.zip") }

  before do
    File.open(file_path, "w") { |f| f.write("dummy content") }

    File.delete(zip_file_path) if File.exist?(zip_file_path)
  end

  after do
    File.delete(file_path) if File.exist?(file_path)
    File.delete(zip_file_path) if File.exist?(zip_file_path)
  end

  describe '#call' do
    subject(:zip_data) { described_class.call(file_path) }

    let(:service_zip_file_path) { zip_data[:zip_file_path] }
    let(:zip_password) { zip_data[:password] }

    it 'creates a zip file containing the original file' do
      expect(File).to exist(service_zip_file_path)

      Zip::File.open(service_zip_file_path) do |zipfile|
        expect(zipfile.find_entry(File.basename(file_path))).not_to be_nil
      end
    end

    it 'creates a zip file with the .zip extension' do
      expect(service_zip_file_path.to_s).to end_with("#{file_name}.zip")
    end

    it 'returns a password for the zip file' do
      expect(zip_password).to be_present
    end
  end
end
