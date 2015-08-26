require 'rails_helper'

describe Api::ThumbnailsHelper, :type => :helper do
  it 'builds the thumbnail uri' do
    Rails.configuration.image_stacks_uri = 'http://stacks.stanford.edu/'
    expect(helper.build_thumbnail_uri('ab123cd4567','19910102120112')).to eq('http://stacks.stanford.edu/ab123cd4567%2F19910102120112/full/200,/0/default.jpg') 
  end
end
