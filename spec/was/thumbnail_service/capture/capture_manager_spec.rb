require 'spec_helper'
include Was::ThumbnailService::Capture

RSpec.configure do |c|
  c.filter_run_excluding :image_prerequisite
end

describe Was::ThumbnailService::Capture::CaptureManager do

  before :each do
    Delayed::Job.delete_all
    SeedUri.delete_all
    Memento.delete_all
  end
  
  describe '.initialize' do
    it 'initializes the CaptureManager with Uri_id' do
      capture_manager = CaptureManager.new(5)
      expect(capture_manager.instance_variable_get(:@uri_id)).to eq(5)
    end
  end

  describe '.submit_capture_jobs' do
    it 'submits jobs based on the available mementos that is_selected but not captured yet' do
      capture_manager = CaptureManager.new(100)
      allow(capture_manager).to receive(:get_druid_id).and_return('ab123cd4567')
      memento1 = Memento.create({ :uri_id=>100, :is_selected => 1, :is_thumbnail_captured => 0})
      memento2 = Memento.create({ :uri_id=>100, :is_selected => 1, :is_thumbnail_captured => 0})
      capture_manager.submit_capture_jobs
      expect(Delayed::Job.all.size).to eq(2)
      expect(Delayed::Job.first.handler).to eq("--- !ruby/struct:Was::ThumbnailService::Capture::CaptureJob\nmemento_id: #{memento1.id}\ndruid_id: ab123cd4567\n")
      expect(Delayed::Job.last.handler).to eq("--- !ruby/struct:Was::ThumbnailService::Capture::CaptureJob\nmemento_id: #{memento2.id}\ndruid_id: ab123cd4567\n")

    end
    it 'avoids the mementos that are not selected yet' do
      capture_manager = CaptureManager.new(100)
      allow(capture_manager).to receive(:get_druid_id).and_return('ab123cd4567')
      Memento.create({ :uri_id=>100, :is_selected => 0, :is_thumbnail_captured => 0})
      Memento.create({ :uri_id=>100, :is_selected => 0, :is_thumbnail_captured => 0})
      capture_manager.submit_capture_jobs
      expect(Delayed::Job.all.size).to eq(0)
    end
    it 'avoids the mementos that are  already captured' do
      capture_manager = CaptureManager.new(100)
      allow(capture_manager).to receive(:get_druid_id).and_return('ab123cd4567')
      Memento.create({ :uri_id=>100, :is_selected => 1, :is_thumbnail_captured => 1})
      Memento.create({ :uri_id=>100, :is_selected => 1, :is_thumbnail_captured => 1})
      capture_manager.submit_capture_jobs
      expect(Delayed::Job.all.size).to eq(0)
    end
    it 'returns succesfully if the uri does not have any memento' do
      capture_manager = CaptureManager.new(100)
      allow(capture_manager).to receive(:get_druid_id).and_return('ab123cd4567')
      capture_manager.submit_capture_jobs
      expect(Delayed::Job.all.size).to eq(0)
    end  
  end

  describe '.get_druid_id' do
    it 'returns the druid_id based on the uri_id' do
      SeedUri.create({:id=>100, :uri=>'http://test1.edu/', :druid_id=>'ab123cd4567'})
      capture_manager = CaptureManager.new(100)
      expect(capture_manager.get_druid_id).to eq('ab123cd4567')
    end
    it 'raises an error if the uri_id is not found' do
      capture_manager = CaptureManager.new(100)
      expect{capture_manager.get_druid_id}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  after :each do
    Delayed::Job.delete_all
    SeedUri.delete_all
    Memento.delete_all
  end
end
