set :bundle_without, %w(deployment development test).join(' ')
set :deploy_environment, 'production'
set :rails_env, fetch(:deploy_environment)

set :whenever_environment, fetch(:deploy_environment)
set :whenever_roles, [:db, :app]
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

server 'was-thumbnail-stage.stanford.edu', user: 'was', roles: %w(web db app)

Capistrano::OneTimeKey.generate_one_time_key!
