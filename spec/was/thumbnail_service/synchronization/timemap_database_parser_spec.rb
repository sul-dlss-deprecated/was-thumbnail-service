require 'spec_helper'

describe Was::ThumbnailService::Synchronization::TimemapDatabaseParser do

  VCR.configure do |config|
    config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
  end
  
  before :all do
    @uri1 = SeedUri.create({:id=>1001, :uri=>"http://test1.edu/", :druid_id=>"druid:aa111aa1111"})
    @memento11 = Memento.create({:id=>10001, :uri_id=>1001, :memento_uri=>"https://swap.stanford.edu/19980901000000/http://test1.edu/", :memento_datetime=>"1998-09-01 00:00:00"})
    @memento12 = Memento.create({:id=>10002, :uri_id=>1001, :memento_uri=>"https://swap.stanford.edu/19990901000000/http://test1.edu/", :memento_datetime=>"1999-09-01 00:00:00"})
    @memento13 = Memento.create({:id=>10003, :uri_id=>1001, :memento_uri=>"https://swap.stanford.edu/20000901000000/http://test1.edu/", :memento_datetime=>"2000-09-01 00:00:00"})
   
    @uri2 = SeedUri.create({:id=>1002, :uri=>"http://test2.edu/", :druid_id=>"druid:aa111aa1111"})
  
    @uri3 = SeedUri.create({:id=>1003, :uri=>"http://test3.edu/", :druid_id=>"druid:aa111aa1111"})
    @memento31 = Memento.create({:id=>10004, :uri_id=>1003, :memento_uri=>"https://swap.stanford.edu/19980901000000/http://test1.edu/", :memento_datetime=>"1998-09-01 00:00:00"})
    @memento32 = Memento.create({:id=>10005, :uri_id=>1003, :memento_uri=>"", :memento_datetime=>"1999-09-01 00:00:00"})
    @memento33 = Memento.create({:id=>10006, :uri_id=>1003,                   :memento_datetime=>"1999-09-01 00:00:00"})
    @memento34 = Memento.create({:id=>10007, :uri_id=>1003, :memento_uri=>"https://swap.stanford.edu/19990901000000/http://test1.edu/", :memento_datetime=>""})
    @memento35 = Memento.create({:id=>10008, :uri_id=>1003, :memento_uri=>"https://swap.stanford.edu/19990901000000/http://test1.edu/"})
    @memento36 = Memento.create({:id=>10009, :uri_id=>1003})
  end

  describe ".get_timemap" do
    it "should return a memento hash for existent uri and available mementos" do
      timemap_parser = Was::ThumbnailService::Synchronization::TimemapDatabaseParser.new("http://test1.edu/")
      mementos_hash =timemap_parser.get_timemap
      expect(mementos_hash.length).to eq(3)
      expect(mementos_hash["19980901000000"]).to eq("https://swap.stanford.edu/19980901000000/http://test1.edu/")
    end
    
    it "should return an empty hash for existent uri without mementos" do
      timemap_parser = Was::ThumbnailService::Synchronization::TimemapDatabaseParser.new("http://test2.edu/")
      mementos_hash =timemap_parser.get_timemap
      expect(mementos_hash.length).to eq(0)
    end

    it "should return avoid the not-complete records " do
      timemap_parser = Was::ThumbnailService::Synchronization::TimemapDatabaseParser.new("http://test3.edu/")
      mementos_hash =timemap_parser.get_timemap
      expect(mementos_hash.length).to eq(1)  
    end
        
    it "should return an empty hash for non-existent uri" do
      timemap_parser = Was::ThumbnailService::Synchronization::TimemapDatabaseParser.new("http://test4.edu/")
      mementos_hash =timemap_parser.get_timemap
      expect(mementos_hash.length).to eq(0)
    end

    it "should return an empty hash for empty uri" do
      timemap_parser = Was::ThumbnailService::Synchronization::TimemapDatabaseParser.new("")
      mementos_hash =timemap_parser.get_timemap
      expect(mementos_hash.length).to eq(0)
    end

    it "should return an empty hash for nil uri" do
      timemap_parser = Was::ThumbnailService::Synchronization::TimemapDatabaseParser.new(nil)
      mementos_hash =timemap_parser.get_timemap
      expect(mementos_hash.length).to eq(0)
    end
  end
  
  after :all do
    @uri1.destroy
    @uri2.destroy
    @uri3.destroy
    @memento11.destroy
    @memento12.destroy
    @memento13.destroy
    @memento31.destroy
    @memento32.destroy
    @memento33.destroy
    @memento34.destroy
    @memento35.destroy
    @memento36.destroy
  end
end