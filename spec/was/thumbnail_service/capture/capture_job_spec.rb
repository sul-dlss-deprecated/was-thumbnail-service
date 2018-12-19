# frozen_string_literal: true

include Was::ThumbnailService::Capture

RSpec.configure do |c|
  c.filter_run_excluding :image_prerequisite
end

describe Was::ThumbnailService::Capture::CaptureJob do
  describe '.perform' do
    it 'calls process thumbnail based on memento id' do
      capture_job = CaptureJob.new(101, 'ab123cd4567')
      capture_thumb = CaptureThumbnail.new(1, '', '', '')
      Memento.create(id: 101, uri_id: 100, memento_uri: 'https://swap.stanford.edu/19980901000000/http://test1.edu/', memento_datetime: '1998-09-01 00:00:00')

      allow(Was::ThumbnailService::Utilities).to receive(:convert_date_to_14_digits).with('1998-09-01 00:00:00 UTC').and_return('19980901000000')
      expect(CaptureThumbnail).to receive(:new).with(101, 'ab123cd4567', 'https://swap.stanford.edu/19980901000000/http://test1.edu/', '19980901000000').and_return(capture_thumb)
      expect_any_instance_of(CaptureThumbnail).to receive(:process_thumbnail)

      capture_job.perform
    end
    it 'raises an error if the record is not found' do
      capture_job = CaptureJob.new(123, 'ab123cd4567')
      expect { capture_job.perform }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
