require 'spec_helper'
include Was::ThumbnailService::Synchronization

describe Was::ThumbnailService::Synchronization::TimemapWaybackParser do
  
  VCR.configure do |config|
    config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    config.hook_into :webmock 
  end
  
  before :all do
    Rails.configuration.wayback_timemap_uri = 'https://swap.stanford.edu/timemap/link/'
    @fixtures = 'spec/fixtures/'
    @timemap_5_mementos = File.read("#{@fixtures}/timemap_5_mementos.txt")
    @rest_404_response  = File.read("#{@fixtures}/404_response.txt")
    @rest_400_response  = File.read("#{@fixtures}/400_response.txt")
    @slac_time = "<http://www.slac.stanford.edu/>; rel=\"original\",\r\n<https://swap.stanford.edu/timemap/link/http://www.slac.stanford.edu/>; rel=\"self\"; type=\"application/link-format\"; from=\"Fri, 22 Dec 1995 00:00:00 GMT\"; until=\"Mon, 04 Jan 1999 00:00:00 GMT\",\r\n<https://swap.stanford.edu/http://www.slac.stanford.edu/>; rel=\"timegate\",\r\n<https://swap.stanford.edu/19951222000000/http://www.slac.stanford.edu/>; rel=\"first memento\"; datetime=\"Fri, 22 Dec 1995 00:00:00 GMT\",\r\n<https://swap.stanford.edu/19961125000000/http://www.slac.stanford.edu/>; rel=\"memento\"; datetime=\"Mon, 25 Nov 1996 00:00:00 GMT\",\r\n<https://swap.stanford.edu/19971219000000/http://www.slac.stanford.edu/>; rel=\"memento\"; datetime=\"Fri, 19 Dec 1997 00:00:00 GMT\",\r\n<https://swap.stanford.edu/19980901000000/http://www.slac.stanford.edu/>; rel=\"memento\"; datetime=\"Tue, 01 Sep 1998 00:00:00 GMT\",\r\n<https://swap.stanford.edu/19990104000000/http://www.slac.stanford.edu/>; rel=\"last memento\"; datetime=\"Mon, 04 Jan 1999 00:00:00 GMT\""
  end
  
  describe '.initialize' do
     it 'initializes the TimemapSynchronization  with uri and uri_id' do
      timemap_parser = TimemapWaybackParser.new('http://test1.edu/')
      expect(timemap_parser.instance_variable_get(:@uri)).to eq('http://test1.edu/')
    end
  end

  describe '.get_timemap' do
    it 'should return memento hash for an existent uri' do
      VCR.use_cassette('slac_timemap') do
        timemap_parser = TimemapWaybackParser.new('http://www.slac.stanford.edu/')
        memento_hash = timemap_parser.get_timemap
        expect(memento_hash.length).to eq(5)
        expect(memento_hash['19951222000000']).to eq('https://swap.stanford.edu/19951222000000/http://www.slac.stanford.edu/')
        expect(memento_hash['19990104000000']).to eq('https://swap.stanford.edu/19990104000000/http://www.slac.stanford.edu/')
      end
    end
    it 'should return an emtpy memento hash for an non-existent uri' do
      VCR.use_cassette('noexistent_timemap') do
        timemap_parser = TimemapWaybackParser.new('http://non.existent.edu')
        memento_hash = timemap_parser.get_timemap
        expect(memento_hash.length).to eq(0)
      end
    end
    it 'should return an emtpy memento hash for an empty uri' do
      timemap_parser = TimemapWaybackParser.new('')
      memento_hash = timemap_parser.get_timemap
      expect(memento_hash.length).to eq(0)
    end
  end
  
  describe '.read_timemap' do
    it 'should download the timemap for existent URI' do
      VCR.use_cassette('slac_timemap') do
        timemap_parser = TimemapWaybackParser.new('http://www.slac.stanford.edu/')
        expect(timemap_parser.read_timemap).to eq(@slac_time)
      end
    end
    it 'should return empty string for non-existent URI' do
      VCR.use_cassette('noexistent_timemap') do
       timemap_parser = TimemapWaybackParser.new('http://non.existent.edu')
        expect(timemap_parser.read_timemap).to eq('')
      end
    end
    it 'should return empty string for empty URI' do
      timemap_parser = TimemapWaybackParser.new('')
      expect(timemap_parser.read_timemap).to eq('')
    end
  end

  describe '.extract_mementos_from_timemap' do
    it 'should return a list of memento hashes' do
      timemap_text = @timemap_5_mementos
      timemap_parser = TimemapWaybackParser.new('')
      memento_hash = timemap_parser.extract_mementos_from_timemap(timemap_text)
      expect(memento_hash.length).to eq(5)
      expect(memento_hash['19951222000000']).to eq('https://swap.stanford.edu/19951222000000/http://test2.edu/')
      expect(memento_hash['19990104000000']).to eq('https://swap.stanford.edu/19990104000000/http://test2.edu/')
    end
    it 'should return an empty list for timemap without mementos' do
       timemap_text="<http://slac.stanford.edu>; rel='original',
<https://swap.stanford.edu/timemap/link/http://slac.stanford.edu>; rel='self'; type='application/link-format'; from='Fri, 22 Dec 1995 00:00:00 GMT'; until='Mon, 04 Jan 1999 00:00:00 GMT',
<https://swap.stanford.edu/http://slac.stanford.edu>; rel='timegate'"
      timemap_parser = TimemapWaybackParser.new('')
      memento_hash = timemap_parser.extract_mementos_from_timemap(timemap_text)
      expect(memento_hash.length).to eq(0)
    end
    it 'should return an empty list for invalid timemap' do
      timemap_text='not valid timemap'
      timemap_parser = TimemapWaybackParser.new('')
      memento_hash = timemap_parser.extract_mementos_from_timemap(timemap_text)
      expect(memento_hash.length).to eq(0)
    end
  end
  
  describe '.extract_memento_from_memento_string' do
    it 'should return memento hash for a valid memento string' do
      timemap_parser = TimemapWaybackParser.new('')
      memento_str = '<https://swap.stanford.edu/19961125000000/http://www.slac.stanford.edu/>; rel="memento"; datetime="Mon, 25 Nov 1996 00:00:00 GMT"'
      memento_hash = timemap_parser.extract_memento_from_memento_string(memento_str)
      expect(memento_hash[:memento_datetime]).to eq('19961125000000')
      expect(memento_hash[:memento_uri]).to eq('https://swap.stanford.edu/19961125000000/http://www.slac.stanford.edu/')
    end
    it 'should return nil for nil memento string' do
      timemap_parser = TimemapWaybackParser.new('')
      memento_hash = timemap_parser.extract_memento_from_memento_string(nil)
      expect(memento_hash).to be_nil
    end
    it 'should return nil for empty memento string' do
      timemap_parser = TimemapWaybackParser.new('')
      memento_hash = timemap_parser.extract_memento_from_memento_string('')
      expect(memento_hash).to be_nil
    end
    it 'should return nil hash for a not-valid memento string' do
      timemap_parser = TimemapWaybackParser.new('')
      memento_str = '<not-valid memento'
      memento_hash = timemap_parser.extract_memento_from_memento_string(memento_str)
      expect(memento_hash).to be_nil
   end
  end

end
