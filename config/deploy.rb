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
set :linked_files, %w(config/database.yml config/honeybadger.yml config/secrets.yml)

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, %w(config/environments log public/system tmp/cache tmp/pids vendor/bundle)
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
# honeybadger_env otherwise defaults to rails_env
set :honeybadger_env, fetch(:stage)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'delayed_job:restart'
  end
end
