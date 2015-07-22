
require 'spec_helper'

RSpec.configure do |c|
  c.filter_run_excluding :image_prerequisite
end

describe Was::ThumbnailService::Capture::CaptureThumbnail do
  
  VCR.configure do |config|
    config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
  end
  
  before :all do
    @fixtures = "spec/fixtures/"
    @memento_html = File.read("#{@fixtures}/memento.txt")
  end
  
  describe ".process_thumbnail" do
    pending
  end
  
  describe ".capture" do
    before :each do
      if File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg") then
        FileUtils.rm("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")
      end
    end
    
    it "should create an jp2 temporary image for a webpage", :image_prerequisite do
      Rails.configuration.jp2_required = true
      VCR.use_cassette("slac_19990104000000") do
        capture_thumbnail = Was::ThumbnailService::Capture::CaptureThumbnail.new(1, "", "https://swap.stanford.edu/19990104000000/http://www.slac.stanford.edu/","19990104000000")
        result = capture_thumbnail.capture
        expect(result.length).to eq(0)
        expect(File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jp2")).to be true
        expect(File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")).to be false
      end
    end

    it "should create an jpeg temporary image for a webpage" do
      Rails.configuration.jp2_required = false
      VCR.use_cassette("slac_19990104000000") do
        capture_thumbnail = Was::ThumbnailService::Capture::CaptureThumbnail.new(1, "", "https://swap.stanford.edu/19990104000000/http://www.slac.stanford.edu/","19990104000000")
        result = capture_thumbnail.capture
        expect(result.length).to eq(0)
        expect(File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jp2")).to be false
        expect(File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")).to be true
      end
    end

    
    it "should return result message if there is an error" do
      VCR.use_cassette("notexistent_20120101120000") do
        capture_thumbnail = Was::ThumbnailService::Capture::CaptureThumbnail.new(1, "", "https://swap.stanford.edu/20120101120000/http://not.existent.edu/","20120101120000")
        result = capture_thumbnail.capture
        expect(result.length).to be > 0
        expect(File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/20120101120000.jpeg")).to be false
        expect(File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/20120101120000.jp2")).to be false
      end
    end
    
    after :each do
      if File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg") then
        FileUtils.rm("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")
      end
      if File.exists?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jp2") then
        FileUtils.rm("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jp2")
      end    
    end
  end
    
  describe ".save_to_stack" do
    before :all do
      tmp_directory = "#{@fixtures}/tmp_directory"
      image_stacks = "#{@fixtures}/image_stacks"
      FileUtils.cp("#{@fixtures}/19961125000000.jpeg","#{tmp_directory}/19961125000000.jpeg")
      FileUtils.cp("#{@fixtures}/19961125000000.jp2","#{tmp_directory}/19961125000000.jp2")
      Rails.configuration.thumbnail_tmp_directory = tmp_directory
      Rails.configuration.image_stacks = image_stacks
    end
    
    it "should copy the thumbnail file from the temp location to the stacks location" do
      Rails.configuration.jp2_required = false
      capture_thumbnail = Was::ThumbnailService::Capture::CaptureThumbnail.new(1, "druid:aa111aa1111", "", "19961125000000")
      capture_thumbnail.save_to_stack

      expect(File.exists?("#{@fixtures}/image_stacks/aa/111/aa/1111/19961125000000.jpeg")).to be true
    end
    
    it "should raise an error if the source file is not available" do       
      Rails.configuration.jp2_required = false
      capture_thumbnail = Was::ThumbnailService::Capture::CaptureThumbnail.new(1, "druid:aa111aaa111", "", "19991125000000")
      expect{capture_thumbnail.save_to_stack}.to raise_error
    end

    it "should copy the thumbnail file from the temp location to the stacks location" do
      Rails.configuration.jp2_required = true
      capture_thumbnail = Was::ThumbnailService::Capture::CaptureThumbnail.new(1, "druid:aa111aa1111", "", "19961125000000")
      capture_thumbnail.save_to_stack

      expect(File.exists?("#{@fixtures}/image_stacks/aa/111/aa/1111/19961125000000.jp2")).to be true
    end
    
    it "should raise an error if the source file is not available" do       
      Rails.configuration.jp2_required = true
      capture_thumbnail = Was::ThumbnailService::Capture::CaptureThumbnail.new(1, "druid:aa111aaa111", "", "19991125000000")
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
      capture_thumbnail = Was::ThumbnailService::Capture::CaptureThumbnail.new(10001, "","https://swap.stanford.edu/19980901000000/http://test1.edu/", "19980901000000")
      capture_thumbnail.update_database
      
      expect(Memento.find(10001)[:is_thumbnail_captured]).to be true
    end
    
    it "should raise an error if the memento id is not found" do
      capture_thumbnail = Was::ThumbnailService::Capture::CaptureThumbnail.new(10002, "", "", "")
      expect{capture_thumbnail.update_database}.to raise_error
    end
    
    after :all do
      @memento11.destroy
    end
  end
  
  describe ".resize_temporary_image" do
    it "resizes the image with extra width to maximum 400 pixel width", :image_prerequisite do
      temporary_image = "tmp/thum_extra_width.jpeg"
      FileUtils.cp "spec/fixtures/thumbnail_files/image_extra_width.jpeg",temporary_image
      Was::ThumbnailService::Capture::CaptureThumbnail.new(1, '', '', '').resize_temporary_image temporary_image
      expect(FileUtils.compare_file(temporary_image, "spec/fixtures/thumbnail_files/thum_extra_width.jpeg")).to be_truthy
    end
    it "resizes the image with extra height to maximum 400 pixel height", :image_prerequisite do
      temporary_image = "tmp/thum_extra_height.jpeg"
      FileUtils.cp "spec/fixtures/thumbnail_files/image_extra_height.jpeg", temporary_image
      Was::ThumbnailService::Capture::CaptureThumbnail.new(1, '', '', '').resize_temporary_image temporary_image
      expect(FileUtils.compare_file(temporary_image, "spec/fixtures/thumbnail_files/thum_extra_height.jpeg")).to be_truthy
    end

    after :each do 
      FileUtils.rm_rf "tmp/thum_extra_width.jpeg" if File.exists?("tmp/thum_extra_width.jpeg")
      FileUtils.rm "tmp/thum_extra_height.jpeg" if File.exists?("tmp/thum_extra_height.jpeg")
    end
  end
end