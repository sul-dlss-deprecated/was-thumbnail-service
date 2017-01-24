RSpec.describe Api::SeedController, :type => :controller do

  describe 'Get create' do
    it 'creates a new record if it does not exist in db' do
      expect(SeedUri.all.length).to eq(0)
      post :create, {:druid=> 'ab123cd4567',:uri=>'http://test1.edu/'}
      expect(response).to have_http_status(200)
      expect(SeedUri.all.length).to eq(1)
    end
    it 'raises an error if there is no parameters or one is missing' do
      expect{post :create}.to raise_error(ActionController::ParameterMissing)
      expect{post :create, {:druid=> 'ab123cd4567'}}.to raise_error(ActionController::ParameterMissing)
      expect{post :create, {:uri=> 'http://example.org'}}.to raise_error(ActionController::ParameterMissing)
    end
    it 'returns 409 if the druid is already exists' do
      SeedUri.create({:id=>100, :uri=>'http://test1.edu/', :druid_id => 'ab123cd4567'})
      expect(SeedUri.all.length).to eq(1)

      post :create, {:druid=> 'ab123cd4567',:uri=>'http://test1.edu/'}
      expect(response).to have_http_status(409)
      expect(SeedUri.all.length).to eq(1)
    end
  end

end
