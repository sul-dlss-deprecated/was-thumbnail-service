# frozen_string_literal: true

describe Was::ThumbnailService::Generator do
  describe '.initialize' do
    it 'initializes the Generator with uri and uri_id' do
      generator = Was::ThumbnailService::Generator.new('http://www.example.org', 5)
      expect(generator.instance_variable_get(:@uri_id)).to eq(5)
      expect(generator.instance_variable_get(:@uri)).to eq('http://www.example.org')
    end
  end

  describe '.run' do
    it 'calls the steps to generate a new set of thumbnails' do
      expect(Was::ThumbnailService::Synchronization::TimemapSynchronization).to receive(:new).with('http://www.example.org', 123).and_return(Was::ThumbnailService::Synchronization::TimemapSynchronization.new('http://www.example.org', 123))
      expect_any_instance_of(Was::ThumbnailService::Synchronization::TimemapSynchronization).to receive(:sync_database)
      expect(Was::ThumbnailService::Picker::MementoPicker).to receive(:new).with(123).and_return(Was::ThumbnailService::Picker::MementoPicker.new(123))
      expect_any_instance_of(Was::ThumbnailService::Picker::MementoPicker).to receive(:pick_mementos)
      expect(Was::ThumbnailService::Capture::CaptureManager).to receive(:new).with(123).and_return(Was::ThumbnailService::Capture::CaptureManager.new(123))
      expect_any_instance_of(Was::ThumbnailService::Capture::CaptureManager).to receive(:submit_capture_jobs)

      generator = Was::ThumbnailService::Generator.new('http://www.example.org', 123)
      generator.run
    end
  end
end
