RSpec.describe AdminController, :type => :controller do

  describe '#thumbnails' do
    it 'raises an error if there is no druid parameter' do
      expect { get :thumbnails }.to raise_error(ActionController::ParameterMissing)
    end
    it 'does not raise error if there is a druid parameter' do
      expect { get :thumbnails, params: { druid: 'ab123cd4567' } }.not_to raise_error
    end
  end

end
