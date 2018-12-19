# frozen_string_literal: true

describe Was::ThumbnailService::Synchronization::TimemapSynchronization do

  VCR.configure do |config|
    config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    config.hook_into :webmock # or :fakeweb
  end

  before :all do
    Settings.wayback_timemap_uri = 'https://swap.stanford.edu/timemap/link/'
    @fixtures = 'spec/fixtures/'
    @timemap_5_mementos = File.read("#{@fixtures}/timemap_5_mementos.txt")
    @rest_404_response  = File.read("#{@fixtures}/404_response.txt")
    Memento.delete_all
    SeedUri.delete_all
  end

  describe '.initialize' do
    it 'initializes the TimemapSynchronization  with uri and uri_id' do
      timemap_synchronization = TimemapSynchronization.new('http://test1.edu/',1)
      expect(timemap_synchronization.instance_variable_get(:@uri)).to eq('http://test1.edu/')
      expect(timemap_synchronization.instance_variable_get(:@uri_id)).to eq(1)
    end
  end

  describe '.sync_database' do
    it 'calls the sync database steps' do
      diff_list = Set.new(['19980101120000','19990101120000'])
      timemap_synchronization = TimemapSynchronization.new('http://test1.edu/',1)
      allow(timemap_synchronization).to receive(:get_timemap_from_database)
      allow(timemap_synchronization).to receive(:get_timemap_from_wayback)
      allow(timemap_synchronization).to receive(:get_timemap_difference_list).and_return(diff_list)
      allow(timemap_synchronization).to receive(:insert_mementos_into_database)

      expect(timemap_synchronization).to receive(:get_timemap_from_database)
      expect(timemap_synchronization).to receive(:get_timemap_from_wayback)
      expect(timemap_synchronization).to receive(:get_timemap_difference_list).and_return(diff_list)
      expect(timemap_synchronization).to receive(:insert_mementos_into_database).with(diff_list)
      timemap_synchronization.sync_database
    end
  end

  describe '.insert_mementos_into_database' do
    it 'should insert new mementos in the database' do
      timemap_synchronization = TimemapSynchronization.new('http://test2.edu/', 1)
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{'19980101120000'=>'uri1','19990101120000'=>'uri1'})
      diff_mementos = Set.new(['19980101120000','19990101120000'])
      timemap_synchronization.insert_mementos_into_database diff_mementos
    end
  end

  describe '.get_timemap_from_database' do
    before :all do
      initialize_database_with_mementos
    end
    it 'should fill database_memento_hash for existent uri' do
      timemap_synchronization = TimemapSynchronization.new('http://test1.edu/', '')
      timemap_synchronization.get_timemap_from_database
      expect(timemap_synchronization.instance_variable_get(:@database_memento_hash).length).to eq(3)
    end
    it 'should keep database_memento_hash emtpy for non-existent uri' do
      timemap_synchronization = TimemapSynchronization.new('http://test4.edu/', '')
      timemap_synchronization.get_timemap_from_database
      expect(timemap_synchronization.instance_variable_get(:@database_memento_hash).length).to eq(0)
    end
  end

  describe '.get_timemap_from_wayback' do
    it 'should fill wayback_memento_hash for existent uri' do
      VCR.use_cassette('slac_timemap') do
        timemap_synchronization = TimemapSynchronization.new('http://www.slac.stanford.edu/', '')
        timemap_synchronization.get_timemap_from_wayback
        expect(timemap_synchronization.instance_variable_get(:@wayback_memento_hash).length).to eq(5)
      end
    end

    it 'should keep wayback_memento_hash emtpy for non-existent uri' do
      VCR.use_cassette('notexistent_timemap') do
        timemap_synchronization = TimemapSynchronization.new('http://non.existent.edu', '')
        timemap_synchronization.get_timemap_from_wayback
        expect(timemap_synchronization.instance_variable_get(:@wayback_memento_hash).length).to eq(0)
      end
    end
  end

  describe '.get_timemap_difference_list' do
    it 'should return empty set for two emtpy hash' do
      timemap_synchronization = TimemapSynchronization.new('', '')
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{})
      timemap_synchronization.instance_variable_set(:@database_memento_hash,{})
      expect(timemap_synchronization.get_timemap_difference_list.length).to eq(0)
    end

    it 'should return the diff list for wayback_hash more than database_hash' do
      timemap_synchronization = TimemapSynchronization.new('', '')
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{'19980101120000'=>'uri1','19990101120000'=>'uri1'})
      timemap_synchronization.instance_variable_set(:@database_memento_hash,{})
      expect(timemap_synchronization.get_timemap_difference_list).to eq(Set.new(['19980101120000','19990101120000']))
    end
    it 'should return the diff list for wayback_hash more than database_hash' do
      timemap_synchronization = TimemapSynchronization.new('', '')
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{'19980101120000'=>'uri1','19990101120000'=>'uri1'})
      timemap_synchronization.instance_variable_set(:@database_memento_hash,{'19980101120000'=>'uri1'})
      expect(timemap_synchronization.get_timemap_difference_list).to eq(Set.new(['19990101120000']))
    end

    it 'should return empty set for two equivalent hash' do
      timemap_synchronization = TimemapSynchronization.new('', '')
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{'19980101120000'=>'uri1','19990101120000'=>'uri1'})
      timemap_synchronization.instance_variable_set(:@database_memento_hash,{'19980101120000'=>'uri1','19990101120000'=>'uri1'})
      expect(timemap_synchronization.get_timemap_difference_list.length).to eq(0)
    end

    it 'should return empty set for database_hash that contains all wayback_hash' do
      timemap_synchronization = TimemapSynchronization.new('', '')
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{})
      timemap_synchronization.instance_variable_set(:@database_memento_hash,{'19980101120000'=>'uri1','19990101120000'=>'uri1'})
      expect(timemap_synchronization.get_timemap_difference_list.length).to eq(0)
    end
  end
end

def initialize_database_with_mementos
  @uri1 = SeedUri.create({ :uri=>'http://test1.edu/', :druid_id=>'aa111aa1111'})
  @memento11 = Memento.create({ :uri_id=>@uri1.id, :memento_uri=>'https://swap.stanford.edu/19980901000000/http://test1.edu/', :memento_datetime=>'1998-09-01 00:00:00'})
  @memento12 = Memento.create({ :uri_id=>@uri1.id, :memento_uri=>'https://swap.stanford.edu/19990901000000/http://test1.edu/', :memento_datetime=>'1999-09-01 00:00:00'})
  @memento13 = Memento.create({ :uri_id=>@uri1.id, :memento_uri=>'https://swap.stanford.edu/20000901000000/http://test1.edu/', :memento_datetime=>'2000-09-01 00:00:00'})

  @uri2 = SeedUri.create({ :uri=>'http://test2.edu/', :druid_id=>'bb111bb1111'})

  @uri3 = SeedUri.create({ :uri=>'http://test3.edu/', :druid_id=>'cc111cc1111'})
  @memento31 = Memento.create({ :uri_id=>@uri2.id, :memento_uri=>'https://swap.stanford.edu/19980901000000/http://test1.edu/', :memento_datetime=>'1998-09-01 00:00:00'})
  @memento32 = Memento.create({ :uri_id=>@uri2.id, :memento_uri=>'', :memento_datetime=>'1999-09-01 00:00:00'})
  @memento33 = Memento.create({ :uri_id=>@uri2.id,                   :memento_datetime=>'1999-09-01 00:00:00'})
  @memento34 = Memento.create({ :uri_id=>@uri2.id, :memento_uri=>'https://swap.stanford.edu/19990901000000/http://test1.edu/', :memento_datetime=>''})
  @memento35 = Memento.create({ :uri_id=>@uri2.id, :memento_uri=>'https://swap.stanford.edu/19990901000000/http://test1.edu/'})
  @memento36 = Memento.create({ :uri_id=>@uri2.id})
end
