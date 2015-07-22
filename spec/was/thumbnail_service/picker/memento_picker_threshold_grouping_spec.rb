require 'spec_helper'

describe Was::ThumbnailService::Picker::MementoPickerThresholdGrouping do
  
  describe '.threshold' do
    it 'reads the default threshold value as 0' do
      Rails.configuration.threshold = nil
      expect(Was::ThumbnailService::Picker::MementoPickerThresholdGrouping.threshold).to eq(0)
    end
    it 'reads the threshold configuration' do
      Rails.configuration.threshold = 5
      expect(Was::ThumbnailService::Picker::MementoPickerThresholdGrouping.threshold).to eq(5)
    end
  end
  
end