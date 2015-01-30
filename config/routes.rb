Rails.application.routes.draw do
  scope '/api' do 
    scope '/v1' do  
      scope '/was' do
        scope '/thumbnails' do
          scope '/druid_id' do
            scope '/:druid_id' do
              get '/' => 'api/thumbnails#list'
            end
          end
          scope 'uri' do
          #  scope '/:uri' do
              get '/' => 'api/thumbnails#list'
          #  end
          end
        end
      end
    end
  end 
end
