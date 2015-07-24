module Was
  module ThumbnailService
    module Capture
      class CaptureManager
        
        def initialize uri_id
          @uri_id = uri_id
        end
        
        def submit_capture_jobs
          druid_id = get_druid_id
          memento_records = Memento.where( 'uri_id = ? AND is_selected = 1 AND is_thumbnail_captured = 0', @uri_id )
          memento_records.each do |memento_record|
            Delayed::Job.enqueue(CaptureJob.new(memento_record['id'], druid_id ))
          end 
        end
      
        def get_druid_id
          return SeedUri.find(@uri_id)['druid_id']
        end
      end
    end
  end
end
