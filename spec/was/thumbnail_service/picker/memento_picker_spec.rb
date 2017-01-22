require 'spec_helper'
include Was::ThumbnailService::Picker

describe Was::ThumbnailService::Picker::MementoPicker do

  describe '.initialize' do
    it 'initializes the object with the parameters' do
      picker = MementoPicker.new(1)
      expect(picker.instance_variable_get(:@uri_id)).to eq(1)
    end
  end

  describe '.pick_mementos' do
    it 'calls the steps to choose the mementos' do
      picker = MementoPicker.new(1)
      mem_list = [{:id=>101, :simhash_value=>9876543210987654321},{:id=>102, :simhash_value=>1234567890123456789}]
      chosen_list = [101, 102]

      allow(picker).to receive(:upload_mementos_list).and_return(mem_list)
      allow(picker).to receive(:choose_mementos).with(mem_list).and_return(chosen_list)
      allow(picker).to receive(:update_chosen_list_database).with(chosen_list)

      expect(picker).to receive(:upload_mementos_list).and_return(mem_list)
      expect(picker).to receive(:choose_mementos).with(mem_list).and_return(chosen_list)
      expect(picker).to receive(:update_chosen_list_database).with(chosen_list)

      picker.pick_mementos
    end
  end

  describe '.upload_mementos_list' do
    before :each do
      Memento.delete_all
      Memento.create({ :id=>101, :uri_id=>1, :simhash_value=>9876543210987654321})
      Memento.create({ :id=>102, :uri_id=>1, :simhash_value=>1234567890123456789})
    end
    it 'fill memento_list with a list of mementos', :mysql do
      picker = MementoPicker.new(1)
      expect(picker.upload_mementos_list).to eq([{:id=>101, :simhash_value=>9876543210987654321},{:id=>102, :simhash_value=>1234567890123456789}])
    end
    it 'keeps the memento_list empty or uri without mementos', :mysql do
      picker = MementoPicker.new(2)
      expect(picker.upload_mementos_list).to eq([])
    end
    after :each do
      Memento.delete_all
    end
  end

  describe '.choose_mementos' do
    it 'calls the Threshold grouping algorithm' do
      picker = MementoPicker.new(1)
      expect(Was::ThumbnailService::Picker::MementoPickerThresholdGrouping).to receive(:choose_mementos).with([])
      picker.choose_mementos([])
    end
  end

  describe '.update_chosen_list_database' do
    before :each do
      Memento.create({:id=>101, :is_selected=>0})
      Memento.create({:id=>102, :is_selected=>0})
    end
    it 'updates the choosen list in the database with is_selected =1 ' do
      picker = MementoPicker.new(1)
      expect(Memento.find(101).is_selected).to eq(false)
      expect(Memento.find(102).is_selected).to eq(false)

      picker.update_chosen_list_database([101,102])
      expect(Memento.find(101).is_selected).to eq(true)
      expect(Memento.find(101).is_selected).to eq(true)
    end
    it 'returns successfully if the chosen_memento_list is empty' do
      picker = MementoPicker.new(1)
      picker.update_chosen_list_database([])
    end
  end

end
