# frozen_string_literal: true

set :application, 'was-thumbnail-service'
set :repo_url, 'https://github.com/sul-dlss/was-thumbnail-service.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :deploy_to, "/opt/app/was/was-thumbnail-service"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w(config/database.yml config/honeybadger.yml config/secrets.yml)

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, %w(log public/system tmp/cache tmp/pids vendor/bundle)
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
# honeybadger_env otherwise defaults to rails_env
set :honeybadger_env, fetch(:stage)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# update shared_configs before restarting app
before 'deploy:restart', 'shared_configs:update'

# restart delayed_job after publishing
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'delayed_job:restart'
  end
end
