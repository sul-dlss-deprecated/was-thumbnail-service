RSpec.describe Api::ThumbnailsController, :type => :controller do
  describe 'Get list' do
    before :all do
    end
    it 'returns 404 if we there is no argument ' do
      get :list
      expect(assigns['seed_uri']).to be_nil
      expect(response).to have_http_status(404)
    end
    it 'returns 404 if the druid_id parameter not found' do
      get :list, params: { :druid_id => 'xy123zz4567', :format => 'json' }
      expect(assigns['seed_uri']).to be_nil
      expect(response).to have_http_status(404)
    end
    it 'returns 404 if the uri parameter not found' do
      get :list, params: { :uri=>'http://www.example.org' }
      expect(assigns['seed_uri']).to be_nil
      expect(response).to have_http_status(404)
    end
    it 'assigns druid_id objects for available seed uri with this druid' do
      insert_seed_only
      get :list, params: { :druid_id => 'ab123cd4567', :format => 'json' }
      expect(assigns['seed_uri']).to eq(@seed_uri)
      expect(assigns['seed_uri'][:druid_id]).to eq('ab123cd4567')
      expect(assigns['memento_records']).to eq([])
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
    end
    it 'assigns druid_id and memento_records for seed uri with available memento', :mysql do
      insert_seed_and_mementos
      get :list, params: { :druid_id => 'ab123cd4567', :format => 'json' }
      expect(assigns['seed_uri']).to eq(@seed_uri)
      expect(assigns['seed_uri'][:druid_id]).to eq('ab123cd4567')
      expect(assigns['memento_records']).to eq([@memento1, @memento2])
      expect(assigns['thumb_size']).to eq(200)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
    end
    it 'assigns the thumb_size based on the submitted value' do
      insert_seed_and_mementos
      get :list, params: { :druid_id => 'ab123cd4567', :format => 'json' }
      expect(assigns['thumb_size']).to eq(200)
    end
    it 'assigns the thumb_size based on the submitted value' do
      insert_seed_and_mementos
      get :list, params: { :druid_id => 'ab123cd4567', :format => 'json', :thumb_size => 400 }
      expect(assigns['thumb_size']).to eq(400)
    end
    it 'assigns the thumb_size based on the submitted value' do
      insert_seed_and_mementos
      get :list, params: { :druid_id => 'ab123cd4567', :format => 'json', :thumb_size => "abcd" }
      expect(assigns['thumb_size']).to eq(200)
    end
    it 'assigns the thumb_size based on the submitted value' do
      insert_seed_and_mementos
      get :list, params: { :druid_id => 'ab123cd4567', :format => 'json', :thumb_size => "0100" }
      expect(assigns['thumb_size']).to eq(100)
    end
  end
  def insert_seed_only
    @seed_uri = SeedUri.create({:id=>100, :uri=>'http://test1.edu/', :druid_id => 'ab123cd4567'})
  end
  def insert_seed_and_mementos
    @seed_uri = SeedUri.create({:id=>100, :uri=>'http://test1.edu/', :druid_id => 'ab123cd4567'})
    @memento1 = Memento.create({:uri_id=>100, :is_selected => 1, :is_thumbnail_captured => 1})
    @memento2 = Memento.create({:uri_id=>100, :is_selected => 1, :is_thumbnail_captured => 1})
    @memento3 = Memento.create({:uri_id=>100, :is_selected => 1, :is_thumbnail_captured => 0})
  end
end
