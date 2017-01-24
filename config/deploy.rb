set :application, 'was-thumbnail-service'
set :repo_url, 'https://github.com/sul-dlss/was-thumbnail-service.git'
set :deploy_host, "was-thumbnail-#{fetch(:stage)}.stanford.edu"
set :user, 'was'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/opt/app/#{fetch(:user)}/#{fetch(:application)}"

server fetch(:deploy_host), user: fetch(:user), roles: %w(web db app)

Capistrano::OneTimeKey.generate_one_time_key!

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w(config/database.yml config/secrets.yml)

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, %w(config/environments log public/system tmp/cache vendor/bundle)
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
      # note that the following doesn't kill old processes due to ? daemon gem
      #   see https://github.com/collectiveidea/delayed_job/issues/3
      # invoke 'delayed_job:restart'
      # this two step approach doesn't always work either
      invoke 'delayed_job:stop'
      invoke 'delayed_job:start'
    end
  end
end
