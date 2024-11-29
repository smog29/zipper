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
    subject(:service_zip_file_path) { described_class.call(file_path) }

    it 'creates a zip file containing the original file' do
      expect(File).to exist(service_zip_file_path)

      Zip::File.open(service_zip_file_path) do |zipfile|
        expect(zipfile.find_entry(File.basename(file_path))).not_to be_nil
      end
    end

    it 'overwrites the zip file with different content if called again' do
      # Check that the original file is in the zip and contains "dummy content"
      Zip::File.open(service_zip_file_path) do |zipfile|
        original_file_content = zipfile.read(File.basename(file_path))
        expect(original_file_content).to eq("dummy content")
      end

      # Modify the file with different content
      File.open(file_path, "w") { |f| f.write("new content") }

      # Run the service again to overwrite the zip file
      described_class.call(file_path)

      # Ensure the zip file exists again after the second call
      expect(File).to exist(service_zip_file_path)

      # Check that the file inside the zip has the new content
      Zip::File.open(service_zip_file_path) do |zipfile|
        new_file_content = zipfile.read(File.basename(file_path))
        expect(new_file_content).to eq("new content")
      end
    end

    it 'creates a zip file with the .zip extension' do
      expect(service_zip_file_path.to_s).to end_with("#{file_name}.zip")
    end
  end
end
