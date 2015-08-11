require 'rails_helper'

RSpec.describe AdminHelper, :type => :helper do
  describe '.get_memento_uri_from_handler' do
    it 'returns the memento uri based on the handler value' do
      handler = "--- !ruby/struct:Was::ThumbnailService::Capture::CaptureJob\nmemento_id: 100\ndruid_id: ab123cd4567\n"
      Memento.create({ :id=>100, :uri_id=>999, :memento_uri=>'https://swap.stanford.edu/19980901000000/http://test1.edu/'})
      expect(helper.get_memento_uri_from_handler handler).to eq('https://swap.stanford.edu/19980901000000/http://test1.edu/')
    end
    it 'raise an exception if the there ' do
      handler = "--- !ruby/struct:Was::ThumbnailService::Capture::CaptureJob\nmemento_id: 500\ndruid_id: ab123cd4567\n"
      expect(helper.get_memento_uri_from_handler handler).to eq("Couldn't find Memento with 'id'=500")
    end
    it 'raise an exception if the there ' do
      handler = "not valid handler"
      helper.get_memento_uri_from_handler handler
      expect(helper.get_memento_uri_from_handler handler).to eq("Problem in extracting memento_id from handler: not valid handler")
    end 
  end

  describe '.extract_memento_id' do
    it 'extracts the memento_id value from the handler' do
      handler = "--- !ruby/struct:Was::ThumbnailService::Capture::CaptureJob\nmemento_id: 11\ndruid_id: ab123cd4567\n"
      expect(helper.extract_memento_id handler).to eq('11')
    end
    it 'raises an error it can not find the druid_id postfix' do
      handler = "--- !ruby/struct:Was::ThumbnailService::Capture::CaptureJob\nmemento_id:"
      expect{helper.extract_memento_id handler}.to raise_error("Problem in extracting memento_id from handler: --- !ruby/struct:Was::ThumbnailService::Capture::CaptureJob\nmemento_id:")
    end
    it 'raises an error it can not find the memento_id prefix' do
      handler = "--- !ruby/struct:Was::ThumbnailService::Capture::CaptureJob\n"
      expect{helper.extract_memento_id handler}.to raise_error("Problem in extracting memento_id from handler: --- !ruby/struct:Was::ThumbnailService::Capture::CaptureJob\n")
    end  
  end

  describe '.extract_memento_uri' do
    it 'returns the memento_uri from a vaild memento record' do
      Memento.create({ :id=>100, :uri_id=>999, :memento_uri=>'https://swap.stanford.edu/19980901000000/http://test1.edu/'})
      expect(helper.extract_memento_uri 100).to eq('https://swap.stanford.edu/19980901000000/http://test1.edu/')
    end
    it 'raises an error for not found id' do
      expect{helper.extract_memento_uri 123}.to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'raises an error for nil id' do
      expect{helper.extract_memento_uri nil}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '.get_druid_from_handler' do
    it 'extracts the druid_id value from the handler' do
      handler = "--- !ruby/struct:Was::ThumbnailService::Capture::CaptureJob\nmemento_id: 11\ndruid_id: ab123cd4567\n"
      expect(helper.get_druid_from_handler handler).to eq('ab123cd4567')
    end
    it 'extracts the druid_id value from the handler' do
      handler = "--- !ruby/struct:Was::ThumbnailService::Capture::CaptureJob\nmemento_id: 11\ndruid_id: \n"
      expect(helper.get_druid_from_handler handler).to eq("\n")
    end
  end
end
