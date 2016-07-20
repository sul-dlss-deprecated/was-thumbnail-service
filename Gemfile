source 'https://rubygems.org'

gem 'rails', '4.1.11'
gem 'mysql2'
gem 'sass-rails', '~> 4.0.3'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

gem 'rest-client'
gem 'simhash' # to compare mementos
# gem 'execjs' # to run JavaScript code from Ruby  # not used??
gem 'therubyracer' # embed the V8 JavaScript interpreter into Ruby
gem 'phantomjs' # headless WebKit scriptable with a JavaScript API
gem 'uglifier'  # js compression

gem 'fastimage'
gem 'mini_magick'
gem 'assembly-image'

gem 'delayed_job_active_record'
gem 'daemons' # ruby code can be run as daemon with simple start/stop/restart commands.
gem 'bluepill' # process monitoring tool
gem 'whenever', :require => false

gem 'druid-tools'
gem 'is_it_working-cbeer'

group :development do
  gem 'sqlite3'
  gem 'spring'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'coveralls', require: false
  gem 'webmock'
  gem 'vcr'
  gem 'database_cleaner'
end

group :deployment do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'dlss-capistrano'
end

group :doc do
  gem 'sdoc', '~> 0.4.0'
  gem 'yard'
end
