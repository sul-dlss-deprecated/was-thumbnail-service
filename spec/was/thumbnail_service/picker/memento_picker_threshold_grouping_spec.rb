include Was::ThumbnailService::Picker

describe Was::ThumbnailService::Picker::MementoPickerThresholdGrouping do

  describe '.choose_mementos' do
    it 'does not raise error when mementos_list is empty array' do
      mem_list = []
      expect { MementoPickerThresholdGrouping.choose_mementos(mem_list) }.not_to raise_error
      expect(MementoPickerThresholdGrouping.choose_mementos(mem_list)).to eq([])
    end
  end

  describe '.simhash_hamming_distance' do
    it 'computes the distance based hamming distance for different numbers' do
      mem_list = [{:id=>101, :simhash_value=>1111111111111111111},{:id=>102, :simhash_value=>1111111111111111112}]
      expect(MementoPickerThresholdGrouping.simhash_hamming_distance(mem_list,0,1)).to eq(4)
    end
    it 'computes the distance based hamming distance for the same number' do
      mem_list = [{:id=>101, :simhash_value=>1111111111111111111},{:id=>102, :simhash_value=>1111111111111111111}]
      expect(MementoPickerThresholdGrouping.simhash_hamming_distance(mem_list,0,1)).to eq(0)
    end
  end

  describe '.threshold' do
    it 'reads the default threshold value as 0' do
      Settings.threshold = nil
      expect(MementoPickerThresholdGrouping.threshold).to eq(0)
    end
    it 'reads the threshold configuration' do
      Settings.threshold = 5
      expect(MementoPickerThresholdGrouping.threshold).to eq(5)
    end
  end
end
