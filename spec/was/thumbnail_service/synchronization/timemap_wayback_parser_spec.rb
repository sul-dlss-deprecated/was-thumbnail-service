
require 'spec_helper'
 
describe Was::ThumbnailService::TimemapWaybackParser do

  before :all do
    @fixtures = "spec/fixtures/"
    @timemap_5_mementos = File.read("#{@fixtures}/timemap_5_mementos.txt")
    @rest_404_response  = File.read("#{@fixtures}/404_response.txt")
    @rest_400_response  = File.read("#{@fixtures}/400_response.txt")
  end

  before :each do
    stub_request(:get, "https://swap.stanford.edu/timemap/link/http://test1.edu/").
      to_return(status: 200, body: "stubbed response", headers: {})
    
    stub_request(:get, "https://swap.stanford.edu/timemap/link/http://test2.edu/").
      to_return(status: 200, body: @timemap_5_mementos, headers: {})

    stub_request(:get, "https://swap.stanford.edu/timemap/link/http://non.existent.edu").
      to_return(status: 404, body: @rest_404_response, headers: {})
      
    stub_request(:get, "https://swap.stanford.edu/timemap/link/").
      to_return(status: 400, body: @rest_400_response, headers: {})
  end

  describe ".get_timemap" do
    it "should return memento hash for an existent uri" do
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("http://test2.edu/")
      memento_hash = timemap_parser.get_timemap
      expect(memento_hash.length).to eq(5)
      expect(memento_hash["19951222000000"]).to eq("https://swap.stanford.edu/19951222000000/http://test2.edu/")
      expect(memento_hash["19990104000000"]).to eq("https://swap.stanford.edu/19990104000000/http://test2.edu/")
    end
    
    it "should return an emtpy memento hash for an non-existent uri" do
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("http://non.existent.edu")
      memento_hash = timemap_parser.get_timemap
      expect(memento_hash.length).to eq(0)
    end
    
    it "should return an emtpy memento hash for an empty uri" do
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("")
      memento_hash = timemap_parser.get_timemap
      expect(memento_hash.length).to eq(0)
    end
  end
  
  describe ".read_timemap" do
    it "should download the timemap for existent URI" do
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("http://test1.edu/")
      expect(timemap_parser.read_timemap).to eq("stubbed response")
    end
    
    it "should return empty string for non-existent URI" do
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("http://non.existent.edu")
      expect(timemap_parser.read_timemap).to eq("")
    end
    
    it "should return empty string for empty URI" do
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("")
      expect(timemap_parser.read_timemap).to eq("")
    end
  end

  describe ".extract_mementos_from_timemap" do
    it "should return a list of memento hashes" do
      timemap_text = @timemap_5_mementos
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("")
      memento_hash = timemap_parser.extract_mementos_from_timemap(timemap_text)
      expect(memento_hash.length).to eq(5)
      expect(memento_hash["19951222000000"]).to eq("https://swap.stanford.edu/19951222000000/http://test2.edu/")
      expect(memento_hash["19990104000000"]).to eq("https://swap.stanford.edu/19990104000000/http://test2.edu/")
    end
    
    it "should return an empty list for timemap without mementos" do
       timemap_text='<http://slac.stanford.edu>; rel="original",
<https://swap.stanford.edu/timemap/link/http://slac.stanford.edu>; rel="self"; type="application/link-format"; from="Fri, 22 Dec 1995 00:00:00 GMT"; until="Mon, 04 Jan 1999 00:00:00 GMT",
<https://swap.stanford.edu/http://slac.stanford.edu>; rel="timegate"'
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("")
      memento_hash = timemap_parser.extract_mementos_from_timemap(timemap_text)
      expect(memento_hash.length).to eq(0)
    end

    it "should return an empty list for invalid timemap" do
      timemap_text='not valid timemap'
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("")
      memento_hash = timemap_parser.extract_mementos_from_timemap(timemap_text)
      expect(memento_hash.length).to eq(0)
    end

  end
  
  describe ".extract_memento_from_memento_string" do
    it "should return memento hash for a valid memento string" do
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("")
      memento_str = '<https://swap.stanford.edu/19961125000000/http://www.slac.stanford.edu/>; rel="memento"; datetime="Mon, 25 Nov 1996 00:00:00 GMT"'
      memento_hash = timemap_parser.extract_memento_from_memento_string(memento_str)
      expect(memento_hash[:memento_datetime]).to eq("19961125000000")
      expect(memento_hash[:memento_uri]).to eq("https://swap.stanford.edu/19961125000000/http://www.slac.stanford.edu/")
    end
    
    it "should return nil for nil memento string" do
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("")
      memento_hash = timemap_parser.extract_memento_from_memento_string(nil)
      expect(memento_hash).to be_nil
    end
    
    it "should return nil for empty memento string" do
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("")
      memento_hash = timemap_parser.extract_memento_from_memento_string("")
      expect(memento_hash).to be_nil
    end
    it "should return nil hash for a not-valid memento string" do
      timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new("")
      memento_str = '<not-valid memento'
      memento_hash = timemap_parser.extract_memento_from_memento_string(memento_str)
      expect(memento_hash).to be_nil
   end

  end

end
