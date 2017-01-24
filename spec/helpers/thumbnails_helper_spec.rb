describe Api::ThumbnailsHelper, :type => :helper do
  it 'builds the thumbnail uri' do
    Rails.configuration.image_stacks_uri = 'http://stacks.stanford.edu/'
    expect(helper.build_thumbnail_uri('ab123cd4567','19910102120112', 400)).to eq('http://stacks.stanford.edu/ab123cd4567%2F19910102120112/full/400,/0/default.jpg')
  end
  it 'builds the iiif info uri' do
    Rails.configuration.image_stacks_uri = 'http://stacks.stanford.edu/'
    expect(helper.build_iiif_json_uri('ab123cd4567','19910102120112')).to eq('http://stacks.stanford.edu/ab123cd4567%2F19910102120112/info.json')
  end
end
