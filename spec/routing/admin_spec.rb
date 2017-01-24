describe 'admin routing specs' do
  context 'thumbnails' do
    it 'routes to admin#thumbnails with druid parameter' do
      expect(get: '/admin/thumbnails?druid=aa123bb4567').to route_to('admin#thumbnails', druid: 'aa123bb4567')
    end
  end
end
