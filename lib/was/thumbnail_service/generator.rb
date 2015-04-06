module Was
  module ThumbnailService
    
    # It is responsible of the syncronization of the Timemap as 
    # recorded in the database and the wayback.
    class Generator
      
      def initialize(uri, uri_id)
        @uri = uri
        @uri_id = uri_id
      end
      def run
        Was::ThumbnailService::Synchronization::TimemapSynchronization.new(@uri, @uri_id).sync_database
        Was::ThumbnailService::Picker::MementoPicker.new(@uri_id).pick_mementos
        Was::ThumbnailService::Capture::CaptureController.new(@uri_id).submit_capture_jobs
      end
    end
  end
end
    