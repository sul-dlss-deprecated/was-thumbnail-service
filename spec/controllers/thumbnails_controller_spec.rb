require 'rails_helper'

RSpec.describe Api::ThumbnailsController, :type => :controller do
  describe 'Get list' do
    it 'returns 404 if we there is no argument ' do
      get :list
      expect(assigns['seed_uri']).to be_nil
      expect(response).to have_http_status(404)
    end
    it 'returns 404 if the druid_id parameter not found' do
      get :list, {:druid_id => 'ab123cd4567', :format => 'json'}
      expect(assigns['seed_uri']).to be_nil
      expect(response).to have_http_status(404)
    end
    it 'returns 404 if the uri parameter not found' do
      get :list, {:uri=>'http://www.example.org'}
      expect(assigns['seed_uri']).to be_nil
      expect(response).to have_http_status(404)
    end
    it 'assigns druid_id objects for available seed uri with this druid' do
      seed_uri = SeedUri.create({:id=>100, :uri=>'http://test1.edu/', :druid_id => 'druid:ab123cd4567'})
      get :list, {:druid_id => 'druid:ab123cd4567', :format => 'json'}
      expect(assigns['seed_uri']).to eq(seed_uri)
      expect(assigns['seed_uri'][:druid_id]).to eq('druid:ab123cd4567')
      expect(assigns['memento_records']).to eq([])
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
    end
    it 'assigns druid_id and memento_records for seed uri with available memento' do
      seed_uri = SeedUri.create({:id=>100, :uri=>'http://test1.edu/', :druid_id => 'druid:ab123cd4567'})
      memento1 = Memento.create( :uri_id=>100, :is_selected => 1, :is_thumbnail_captured => 1)
      memento2 = Memento.create({ :uri_id=>100, :is_selected => 1, :is_thumbnail_captured => 1})
      memento3 = Memento.create({ :uri_id=>100, :is_selected => 1, :is_thumbnail_captured => 0})
      get :list, {:druid_id => 'druid:ab123cd4567', :format => 'json'}
      expect(assigns['seed_uri']).to eq(seed_uri)
      expect(assigns['seed_uri'][:druid_id]).to eq('druid:ab123cd4567')
      expect(assigns['memento_records']).to eq([memento1, memento2])
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
    end
  end
end
