# frozen_string_literal: true

module Was
  module ThumbnailService
    module Capture
      CaptureJob = Struct.new(:memento_id, :druid_id) do
        def perform
          memento = Memento.find(memento_id.to_i)
          memento_datetime_14_d = Was::ThumbnailService::Utilities.convert_date_to_14_digits(memento['memento_datetime'].to_s)
          capture_thumbnail = Was::ThumbnailService::Capture::CaptureThumbnail.new(memento['id'], druid_id, memento['memento_uri'], memento_datetime_14_d)
          capture_thumbnail.process_thumbnail
        end
      end
    end
  end
end
