require 'spec_helper' 

describe Was::ThumbnailService::TimemapSynchronization do

  before :all do
    @fixtures = "spec/fixtures/"
    @timemap_5_mementos = File.read("#{@fixtures}/timemap_5_mementos.txt")
    @rest_404_response  = File.read("#{@fixtures}/404_response.txt")
  end

  before :each do
    stub_request(:get, "https://swap.stanford.edu/timemap/link/http://test2.edu/").
      to_return(status: 200, body: @timemap_5_mementos, headers: {})

    stub_request(:get, "https://swap.stanford.edu/timemap/link/http://non.existent.edu").
      to_return(status: 404, body: @rest_404_response, headers: {})
  end

  describe ".sync_database" do
    pending
  end

  describe ".insert_mementos_into_database" do
    it "should instert " do
      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("http://test2.edu/", 1)
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{"19980101120000"=>"uri1","19990101120000"=>"uri1"})
      diff_mementos = Set.new(["19980101120000","19990101120000"])
      timemap_synchronization.insert_mementos_into_database diff_mementos
    end
    pending
  end
  
  describe ".get_timemap_from_database" do
    before :all do
      initialize_database_with_mementos
    end
    
    it "should fill database_memento_hash for existent uri" do
      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("http://test1.edu/", "")
      timemap_synchronization.get_timemap_from_database
      expect(timemap_synchronization.instance_variable_get(:@database_memento_hash).length).to eq(3)
    end
 
    it "should keep database_memento_hash emtpy for non-existent uri" do
      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("http://test4.edu/", "")
      timemap_synchronization.get_timemap_from_database
      expect(timemap_synchronization.instance_variable_get(:@database_memento_hash).length).to eq(0)
    end
     
    after :all do
      destroy_database_mementos
    end
  end
  
  describe ".get_timemap_from_wayback" do
    it "should fill wayback_memento_hash for existent uri" do
      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("http://test2.edu/", "")
      timemap_synchronization.get_timemap_from_wayback
      expect(timemap_synchronization.instance_variable_get(:@wayback_memento_hash).length).to eq(5)
    end
 
    it "should keep wayback_memento_hash emtpy for non-existent uri" do
      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("http://non.existent.edu", "")
      timemap_synchronization.get_timemap_from_wayback
      expect(timemap_synchronization.instance_variable_get(:@wayback_memento_hash).length).to eq(0)
    end
  end

  describe ".get_timemap_difference_list" do
    it "should return empty set for two emtpy hash" do
      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("", "")
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{})
      timemap_synchronization.instance_variable_set(:@database_memento_hash,{})
      expect(timemap_synchronization.get_timemap_difference_list.length).to eq(0)
    end
    
    it "should return the diff list for wayback_hash more than database_hash" do
      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("", "")
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{"19980101120000"=>"uri1","19990101120000"=>"uri1"})
      timemap_synchronization.instance_variable_set(:@database_memento_hash,{})
      expect(timemap_synchronization.get_timemap_difference_list).to eq(Set.new(["19980101120000","19990101120000"]))
    end
    it "should return the diff list for wayback_hash more than database_hash" do
      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("", "")
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{"19980101120000"=>"uri1","19990101120000"=>"uri1"})
      timemap_synchronization.instance_variable_set(:@database_memento_hash,{"19980101120000"=>"uri1"})
      expect(timemap_synchronization.get_timemap_difference_list).to eq(Set.new(["19990101120000"]))
    end
    
    it "should return empty set for two equivalent hash" do
      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("", "")
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{"19980101120000"=>"uri1","19990101120000"=>"uri1"})
      timemap_synchronization.instance_variable_set(:@database_memento_hash,{"19980101120000"=>"uri1","19990101120000"=>"uri1"})
      expect(timemap_synchronization.get_timemap_difference_list.length).to eq(0)
    end
     
    it "should return empty set for database_hash that contains all wayback_hash" do
      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("", "")
      timemap_synchronization.instance_variable_set(:@wayback_memento_hash,{})
      timemap_synchronization.instance_variable_set(:@database_memento_hash,{"19980101120000"=>"uri1","19990101120000"=>"uri1"})
      expect(timemap_synchronization.get_timemap_difference_list.length).to eq(0)
    end
  end

#  describe ".uri_id" do
#    before :each do
#      @uri = SeedUri.create({:id=>9999, :uri=>"http://test.edu/", :druid_id=>"druid:aa111aa1111"})
#    end
    
#    it "should return valid id number for valid uri string" do
#      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("http://test.edu/", "")
#      expect(timemap_synchronization.uri_id).to eq(9999)
#    end
 
#    it "should return -1 for not-valid uri string" do
#      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new("http://doesn.t.exist", "")
#      expect(timemap_synchronization.uri_id).to eq(-1)
#    end
    
#    it "should return -1 for not-valid uri string" do
#      timemap_synchronization = Was::ThumbnailService::TimemapSynchronization.new(nil, "")
#      expect(timemap_synchronization.uri_id).to eq(-1)
#    end
    
#    after :each do
#      @uri.destroy
#    end
#  end
end

def initialize_database_with_mementos
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

def destroy_database_mementos
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
