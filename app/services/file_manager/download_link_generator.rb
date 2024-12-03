module FileManager
  class DownloadLinkGenerator < ApplicationService
    def initialize(blob)
      @blob = blob
    end

    def call
      Rails.application.routes.url_helpers.rails_blob_url(blob, disposition: "attachment")
    end

    private

    attr_reader :blob
  end
end
