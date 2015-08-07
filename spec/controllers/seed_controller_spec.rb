require 'rails_helper'

RSpec.describe Api::SeedController, :type => :controller do
  describe 'Get create' do
    it 'creates a new record if it does not exist in db' do
      expect(SeedUri.all.length).to eq(0)
      get :create, {:druid=> 'ab123cd4567',:uri=>'http://test1.edu/'}
      expect(response).to have_http_status(200)
      expect(SeedUri.all.length).to eq(1)
    end
    it 'returns 400 if there is no parameters or one is missing' do
      get :create
      expect(response).to have_http_status(400)
      
      get :create, {:druid=> 'ab123cd4567'}
      expect(response).to have_http_status(400)
      
      get :create, {:uri=> 'http://example.org'}
      expect(response).to have_http_status(400)
    end
    it 'returns 409 if the druid is already exists' do
      SeedUri.create({:id=>100, :uri=>'http://test1.edu/', :druid_id => 'ab123cd4567'})
      expect(SeedUri.all.length).to eq(1)
      
      get :create, {:druid=> 'ab123cd4567',:uri=>'http://test1.edu/'}
      expect(response).to have_http_status(409)
      expect(SeedUri.all.length).to eq(1)
    end
  end
  
end
