describe 'api routing specs' do
  context 'v1/was/thumbnails/druid_id' do
    it 'routes to api/thumbnails#list when there is a druid' do
      expect(get: '/api/v1/was/thumbnails/druid_id/aa123bb4567').to route_to('api/thumbnails#list', druid_id: 'aa123bb4567')
    end
    it 'is not routable without druid' do
      expect(get: '/api/v1/was/thumbnails/druid_id').not_to be_routable
    end
  end
end
