module FileManager
  class DownloadLinkGenerator < ApplicationService
    attr_reader :blob

    def initialize(blob)
      @blob = blob
    end

    def call
      Rails.application.routes.url_helpers.rails_blob_url(blob, disposition: "attachment")
    end
  end
end
