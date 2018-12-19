# frozen_string_literal: true

describe JobsHelper, :type => :helper do
  describe '.get_thumbnail_uri' do
    it 'returns the full uri for the thumbnail' do
      Settings.image_stacks_uri = 'http://stacks.example.org/'
      expect(helper.get_thumbnail_uri 'ab123cd4567', '19991212000000').to eq('http://stacks.example.org/ab123cd4567%2F19991212000000/full/full/0/default.jpg')
    end
  end
end
