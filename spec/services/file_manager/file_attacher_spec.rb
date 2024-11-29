require 'rails_helper'

RSpec.describe FileManager::FileAttacher, type: :service do
  let(:user) { create(:user) }
  let(:file_path) { Rails.root.join("tmp", "test_file.txt") }

  before do
    FileUtils.mkdir_p(Rails.root.join("tmp"))
    File.open(file_path, "w") { |f| f.write("dummy content") }
  end

  after do
    File.delete(file_path) if File.exist?(file_path)
  end

  describe '#call' do
    subject(:blob) { described_class.call(user, file_path) }

    it 'attaches the file to the user' do
      expect(blob).to be_present
      expect(blob.filename.to_s).to eq(File.basename(file_path))
      expect(blob.content_type).to eq("text/plain")

      expect(user.files.attached?).to be true
    end
  end
end
