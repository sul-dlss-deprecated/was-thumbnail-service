require 'rails_helper'

  describe 'api/thumbnails/list' do
    it 'renders the list.json' do
      seed_uri = SeedUri.create({:id=>100, :uri=>'http=>//test1.edu/', :druid_id=>'druid=>ab123cd4567'})
      memento1 = Memento.create({ :uri_id=>100, :memento_uri=> 'https://swap.stanford.edu/20120102131415/http://test1.edu/', :memento_datetime=>'20120102131415'})
      memento2 = Memento.create({ :uri_id=>100, :memento_uri=> 'https://swap.stanford.edu/20120102131416/http://test1.edu/', :memento_datetime=>'20120102131416'})
      assign('memento_records',[memento1,memento2])
      assign('druid_id','ab123cd4567')
      Rails.configuration.image_stacks_uri = "http://stacks.stanford.edu/"
      render(:template=>'api/thumbnails/list.json.jbuilder')
      expect(rendered).to eq({"thumbnails"=>[{"memento_uri"=>"https://swap.stanford.edu/20120102131415/http://test1.edu/",
                                              "memento_datetime"=>"20120102131415",
                                              "thumbnail_uri"=>"http://stacks.stanford.edu/ab123cd4567%2F20120102131415/full/200,/0/default.jpg"},
                                            {"memento_uri"=>"https://swap.stanford.edu/20120102131416/http://test1.edu/",
                                              "memento_datetime"=>"20120102131416",
                                              "thumbnail_uri"=>"http://stacks.stanford.edu/ab123cd4567%2F20120102131416/full/200,/0/default.jpg"}]}.to_json)
    end
    it 'retuns an empty response for empy memento records' do
      assign('memento_records',[])
       render(:template=>'api/thumbnails/list.json.jbuilder')
      expect(rendered).to eq({"thumbnails"=>[]}.to_json)
    end
    
  end