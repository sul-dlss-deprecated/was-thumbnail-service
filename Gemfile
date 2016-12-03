source 'https://rubygems.org'

gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'mysql2', '~> 0.3.21' # issue with Rails 4.1.x and 4.2.x https://github.com/rails/rails/issues/21544
gem 'rails', '~> 4.2.7.1'
gem 'sass-rails', '~> 4.0.5'  # use SCSS as CSS preprocessor
gem 'turbolinks'

gem 'rest-client', '~> 1.8' # pinned to 1.x release line as 2.x breaks rake was_thumbnail_service:run_thumbnail_monitor
gem 'simhash' # to compare mementos

gem 'phantomjs' # headless WebKit scriptable with a JavaScript API
gem 'therubyracer' # embed the V8 JavaScript interpreter into Ruby
gem 'uglifier'  # js compression

gem 'assembly-image'
gem 'fastimage'
gem 'mini_magick'

gem 'daemons' # ruby code can be run as daemon with simple start/stop/restart commands.
gem 'delayed_job_active_record'
gem 'whenever', :require => false

gem 'druid-tools'
gem 'okcomputer'

group :development, :test do
  gem 'rubocop'
  gem 'sqlite3'
end

group :development do
  gem 'spring'
end

group :test do
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'responders', '~> 2.0'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'vcr'
  gem 'webmock'
end

group :deployment do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'dlss-capistrano'
end

group :doc do
  gem 'sdoc'
  gem 'yard'
end
