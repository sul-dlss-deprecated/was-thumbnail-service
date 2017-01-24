module Was
  module ThumbnailService

    # Synchronizes Timemap between app database and the wayback server.
    class Generator

      def initialize(uri, uri_id)
        @uri = uri
        @uri_id = uri_id
      end

      def run
        Was::ThumbnailService::Synchronization::TimemapSynchronization.new(@uri, @uri_id).sync_database
        Was::ThumbnailService::Picker::MementoPicker.new(@uri_id).pick_mementos
        Was::ThumbnailService::Capture::CaptureManager.new(@uri_id).submit_capture_jobs
      end
    end
  end
end
