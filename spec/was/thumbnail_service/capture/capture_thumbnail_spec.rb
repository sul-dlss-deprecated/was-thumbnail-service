
require 'spec_helper'
 

describe Was::ThumbnailService::CaptureThumbnail do
  
  before :all do
    @fixtures = "spec/fixtures/"
    @memento_html = File.read("#{@fixtures}/memento.txt")
  
  end
  
  before :each do
  end
  describe ".process_thumbnail" do
    pending
  end
  
  describe ".capture" do
    before :each do
      if File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpg") then
        FileUtils.rm("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpg")
      end
    end
    
    it "should create an temporary image for a webpage" do
      capture_thumbnail = Was::ThumbnailService::CaptureThumbnail.new(1, "", "https://swap.stanford.edu/19990104000000/http://www.slac.stanford.edu/","19990104000000")
      result = capture_thumbnail.capture
      expect(result.length).to eq(0)
      expect(File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpg")).to be true
    end
    
    it "should return result message if there is an error" do
      capture_thumbnail = Was::ThumbnailService::CaptureThumbnail.new(1, "", "https://swap.stanford.edu/20120101120000/http://not.existent.edu/","20120101120000")
      result = capture_thumbnail.capture
      expect(result.length).to be > 0
      expect(File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/20120101120000.jpg")).to be false
    end
    
    after :each do
      if File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpg") then
        FileUtils.rm("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpg")
      end
    end
  end
    
  describe ".save_to_stack" do
    before :all do
      FileUtils.cp("#{@fixtures}/19961125000000.jpg","#{@fixtures}/tmp_directory/19961125000000.jpg")
      tmp_directory = "#{@fixtures}/tmp_directory"
      image_stacks = "#{@fixtures}/image_stacks"
      Rails.configuration.thumbnail_tmp_directory = tmp_directory
      Rails.configuration.image_stacks = image_stacks
    end
    
    it "should copy the thumbnail file from the temp location to the stacks location" do
      capture_thumbnail = Was::ThumbnailService::CaptureThumbnail.new(1, "druid:aa111aa1111", "", "19961125000000")
      capture_thumbnail.save_to_stack

      expect(File.exists?("#{@fixtures}/image_stacks/aa/111/aa/1111/19961125000000.jpg")).to be true
    end
    
    it "should raise an error if the source file is not available" do
      capture_thumbnail = Was::ThumbnailService::CaptureThumbnail.new(1, "druid:aa111aaa111", "", "19991125000000")
      expect{capture_thumbnail.save_to_stack}.to raise_error
    end
    
    after :all do
        if File.exists?("#{@fixtures}/image_stacks/aa/") then
        FileUtils.rm_r("#{@fixtures}/image_stacks/aa/")
      end
    end
  end
  
  describe ".update_database" do
    before :all do
      @memento11 = Memento.create({:id=>10001, :uri_id=>1001, :memento_uri=>"https://swap.stanford.edu/19980901000000/http://test1.edu/", :memento_datetime=>"1998-09-01 00:00:00", :is_selected=>"true", :is_thumbnail_captured=>"False"})
    end

    it "should update is_thumbnail_captured for the memento record in the database" do
      capture_thumbnail = Was::ThumbnailService::CaptureThumbnail.new(10001, "","https://swap.stanford.edu/19980901000000/http://test1.edu/", "19980901000000")
      capture_thumbnail.update_database
      
      expect(Memento.find(10001)[:is_thumbnail_captured]).to be true
    end
    
    it "should raise an error if the memento id is not found" do
      capture_thumbnail = Was::ThumbnailService::CaptureThumbnail.new(10002, "", "", "")
      expect{capture_thumbnail.update_database}.to raise_error
    end
    
    after :all do
      @memento11.destroy
    end
  end
end