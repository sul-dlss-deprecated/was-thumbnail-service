# frozen_string_literal: true

Rails.application.routes.draw do

  root to: "admin#seeds"

  get 'jobs/retry'

  get 'jobs/remove'

  get 'admin/jobs'

  get 'admin/seeds'

  get 'admin/errors'

  get 'admin/thumbnails'

  get 'api/seed/list'

  get 'api/seed/create'

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
            get '/' => 'api/thumbnails#list'
          end
        end
      end
    end
  end
end
