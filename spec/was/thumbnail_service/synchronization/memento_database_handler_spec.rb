
require 'spec_helper'
 

describe Was::ThumbnailService::MementoDatabaseHandler do

  before :all do
  end

  before :each do
    stub_request(:get, "https://swap.stanford.edu/20120101120000id_/http://test1.edu/").
      to_return(status: 200, body: "This is memento text.", headers: {})
    stub_request(:get, "https://swap.stanford.edu/20120101120000id_/http://test2.edu/").
      to_return(status: 404, body: "This is not a memento text.", headers: {})
  
  end

  describe ".insert_memento_into_databse" do
    it "should raise an error if any required fields is missing" do
       m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(nil, "https://swap.stanford.edu/20120101120000/http://test1.edu/", "Mon, 23 Nov 2001 12:00:00")
       m_db_handler.instance_variable_set(:@simhash_value,"1234")
       expect{m_db_handler.insert_memento_into_databse}.to raise_error
      
       m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, "", "Mon, 23 Nov 2001 12:00:00")
       m_db_handler.instance_variable_set(:@simhash_value,"1234")
       expect{m_db_handler.insert_memento_into_databse}.to raise_error
      
       m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, "https://swap.stanford.edu/20120101120000/http://test1.edu/", "")
       m_db_handler.instance_variable_set(:@simhash_value,"1234")
       expect{m_db_handler.insert_memento_into_databse}.to raise_error
      
       m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, "https://swap.stanford.edu/20120101120000/http://test1.edu/", "Mon, 23 Nov 2001 12:00:00")
       expect{m_db_handler.insert_memento_into_databse}.to raise_error

       m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, "https://swap.stanford.edu/20120101120000/http://test1.edu/", "Mon, 23 Nov 2001 12:00:00")
       m_db_handler.instance_variable_set(:@simhash_value,0)
       expect{m_db_handler.insert_memento_into_databse}.to raise_error
    end
    
    it "should insert memento into the database" do
       m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(9999, "https://swap.stanford.edu/20120101120000/http://test1.edu/", "Mon, 23 Nov 2001 12:00:00")
       m_db_handler.instance_variable_set(:@simhash_value,9342137274140115447)
       m_db_handler.insert_memento_into_databse
       
       @test_memento = Memento.find_by( memento_uri: "https://swap.stanford.edu/20120101120000/http://test1.edu/")
       expect(@test_memento[:uri_id]).to eq(9999)
       expect(@test_memento[:memento_uri]).to eq("https://swap.stanford.edu/20120101120000/http://test1.edu/")
       expect(@test_memento[:memento_datetime]).to eq("2001-11-23 12:00:00")
       expect(@test_memento[:simhash_value]).to eq(9342137274140115447)
       expect(@test_memento[:is_selected]).to eq(false)
       expect(@test_memento[:is_thumbnail_captured]).to eq(false)
    end
    
    after :each do
      unless @test_memento.nil? then
        @test_memento.destroy
      end
    end
  end

  describe ".compute_simhash_value" do
    it "should return valid simhash for a string" do
      m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, "", "")
      simhash_value = m_db_handler.compute_simhash_value("I'm a basic string")
      expect(simhash_value).to eq(9342137274140115447)
    end

    it "should return 0 for emtpy string" do
      m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, "", "")
      simhash_value = m_db_handler.compute_simhash_value("")
      expect(simhash_value).to eq(0)
    end
    it "should return 0 for emtpy string" do
      m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, "", "")
      simhash_value = m_db_handler.compute_simhash_value(nil)
      expect(simhash_value).to eq(0)
    end


  end

  describe ".download_memento_text" do
    it "should download the memento text for available memento" do
      m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, "https://swap.stanford.edu/20120101120000/http://test1.edu/", "")
      memento_text = m_db_handler.download_memento_text
      expect(memento_text).to eq("This is memento text.")
    end
    
    it "should return an emtpy string for non-available memento" do
      m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, "https://swap.stanford.edu/20120101120000/http://test2.edu/", "")
      memento_text = m_db_handler.download_memento_text
      expect(memento_text).to eq("")
    end
    
    it "should return an emtpy string for not-valid memento" do
      m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, "https://swap.stanford.edu/20120101/http://test2.edu/", "")
      memento_text = m_db_handler.download_memento_text
      expect(memento_text).to eq("")
    end
    
     it "should return an emtpy string for empty memento uri" do
      m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, "", "")
      memento_text = m_db_handler.download_memento_text
      expect(memento_text).to eq("")
    end
    
    it "should return an emtpy string for nil memento uri" do
      m_db_handler = Was::ThumbnailService::MementoDatabaseHandler.new(1, nil, "")
      memento_text = m_db_handler.download_memento_text
      expect(memento_text).to eq("")
    end
  end
end
