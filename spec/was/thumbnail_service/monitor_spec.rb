# frozen_string_literal: true

describe Was::ThumbnailService::Monitor do
  describe '.run' do
    before :each do
      SeedUri.delete_all
    end
    it 'ends silently if there is no seed uris' do
      expect(Was::ThumbnailService::Generator).to_not receive(:run)
      expect { Was::ThumbnailService::Monitor.run }.to_not raise_error
    end
    it 'does not call generator run if there are no mementos for the seed' do
      Memento.delete_all
      SeedUri.create(id: 1001, uri: 'http://test1.edu/', druid_id: 'aa111aa1111')
      expect(Was::ThumbnailService::Generator).to_not receive(:run)
      expect { Was::ThumbnailService::Monitor.run }.to_not raise_error
    end
    it 'does not call generator run if the mementos wayback equals to mementos db' do
      SeedUri.create(id: 1001, uri: 'http://test1.edu/', druid_id: 'aa111aa1111')
      allow(Was::ThumbnailService::Monitor).to receive(:count_mementos_in_database).and_return(4)
      allow(Was::ThumbnailService::Monitor).to receive(:count_mementos_in_wayback).and_return(4)
      expect(Was::ThumbnailService::Generator).to_not receive(:run)
      Was::ThumbnailService::Monitor.run
    end
    it 'calls generator run if the mementos wayback greater mementos db' do
      SeedUri.create(id: 1001, uri: 'http://test1.edu/', druid_id: 'aa111aa1111')
      allow(Was::ThumbnailService::Monitor).to receive(:count_mementos_in_database).with(1001).and_return(4)
      allow(Was::ThumbnailService::Monitor).to receive(:count_mementos_in_wayback).with('http://test1.edu/').and_return(5)
      allow_any_instance_of(Was::ThumbnailService::Generator).to receive(:run)

      expect_any_instance_of(Was::ThumbnailService::Generator).to receive(:run)
      Was::ThumbnailService::Monitor.run
    end
    it 'calls generator run if there is new mementos and skip for the same number' do
      SeedUri.create(id: 1001, uri: 'http://test1.edu/', druid_id: 'aa111aa1111')
      SeedUri.create(id: 1002, uri: 'http://test2.edu/', druid_id: 'bb111bb1111')
      allow(Was::ThumbnailService::Monitor).to receive(:count_mementos_in_database).with(1001).and_return(4)
      allow(Was::ThumbnailService::Monitor).to receive(:count_mementos_in_wayback).with('http://test1.edu/').and_return(4)

      allow(Was::ThumbnailService::Monitor).to receive(:count_mementos_in_database).with(1002).and_return(4)
      allow(Was::ThumbnailService::Monitor).to receive(:count_mementos_in_wayback).with('http://test2.edu/').and_return(5)

      allow_any_instance_of(Was::ThumbnailService::Generator).to receive(:run)

      expect_any_instance_of(Was::ThumbnailService::Generator).to receive(:run).once
      Was::ThumbnailService::Monitor.run
    end
    after :each do
      SeedUri.delete_all
    end
  end

  describe '.count_mementos_in_wayback' do
    it 'returns the number of keys for timemap with mementos' do
      wb_hash = { '19951222000000' => 'https://swap.stanford.edu/19951222000000/http://test2.edu/',
                  '19961125000000' => 'https://swap.stanford.edu/19961125000000/http://test2.edu/',
                  '19971219000000' => 'https://swap.stanford.edu/19971219000000/http://test2.edu/',
                  '19980901000000' => 'https://swap.stanford.edu/19980901000000/http://test2.edu/',
                  '19990104000000' => 'https://swap.stanford.edu/19990104000000/http://test2.edu/' }
      allow_any_instance_of(Was::ThumbnailService::Synchronization::TimemapWaybackParser).to receive(:timemap).and_return(wb_hash)
      expect(Was::ThumbnailService::Synchronization::TimemapWaybackParser).to receive(:new).with('uri')
                                                                                           .and_return(Was::ThumbnailService::Synchronization::TimemapWaybackParser.new('uri'))
      expect(Was::ThumbnailService::Monitor.count_mementos_in_wayback('uri')).to eq(5)
    end
    it 'returns 0 for emtpy hash' do
      wb_hash = {}
      allow_any_instance_of(Was::ThumbnailService::Synchronization::TimemapWaybackParser).to receive(:timemap).and_return(wb_hash)
      expect(Was::ThumbnailService::Monitor.count_mementos_in_wayback('uri')).to eq(0)
    end
    it 'returns 0 for nil hash' do
      wb_hash = nil
      allow_any_instance_of(Was::ThumbnailService::Synchronization::TimemapWaybackParser).to receive(:timemap).and_return(wb_hash)
      expect(Was::ThumbnailService::Monitor.count_mementos_in_wayback('uri')).to eq(0)
    end
  end

  describe '.count_mementos_in_database' do
    before :each do
      Memento.delete_all
    end
    it 'returns positive number for the uri with memento' do
      Memento.create(id: 101, uri_id: 100)
      Memento.create(id: 102, uri_id: 100)
      Memento.create(id: 103, uri_id: 100)
      expect(Was::ThumbnailService::Monitor.count_mementos_in_database(100)).to eq(3)
    end
    it 'returns 0 if there is no memento for this uri id' do
      expect(Was::ThumbnailService::Monitor.count_mementos_in_database(200)).to eq(0)
    end
    after :each do
      Memento.delete_all
    end
  end
end
