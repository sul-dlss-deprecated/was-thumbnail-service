# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 5.2.2'
gem 'responders' # controller-level `respond_to' feature now in `responders` gem as of rails 4.2
gem 'mysql2'
gem 'sass-rails', '~> 5.0'  # use SCSS as CSS preprocessor

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

gem 'rest-client', '~> 2.0'
gem 'simhash' # to compare mementos

gem 'phantomjs' # headless WebKit scriptable with a JavaScript API
gem 'uglifier' # js compression

gem 'fastimage'
gem 'mini_magick'
gem 'assembly-image'

gem 'delayed_job_active_record'
gem 'daemons' # ruby code can be run as daemon with simple start/stop/restart commands.
gem 'whenever', :require => false

gem 'config'
gem 'druid-tools'
gem 'honeybadger' # for exception reporting
gem 'okcomputer' # for 'upness' monitoring

group :development, :test do
  gem 'rubocop', '~> 0.53.0' # avoid code churn due to rubocop changes
  gem 'sqlite3'
end

group :development do
  gem 'spring'
end

group :test do
  gem 'rspec-rails'
  gem 'coveralls', require: false
  gem 'capybara'
  gem 'webmock'
  gem 'vcr'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

group :deployment do
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'dlss-capistrano'
end

group :doc do
  gem 'sdoc'
end
