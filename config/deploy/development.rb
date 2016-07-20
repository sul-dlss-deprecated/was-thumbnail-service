server 'was-thumbnail-dev.stanford.edu', user: 'was', roles: %w{web app db}

Capistrano::OneTimeKey.generate_one_time_key!

set :bundle_without, %w{deployment test}.join(' ')
set :deploy_environment, 'development'

set :whenever_environment, fetch(:deploy_environment)
set :whenever_roles, [:db, :app]
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
