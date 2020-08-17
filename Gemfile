# frozen_string_literal: true

source 'https://rubygems.org'

gem 'mysql2', '< 0.5.3' # because incompatible w/ MySQL we have deployed (5.1)
gem 'rails', '~> 5.2.2'
gem 'responders' # controller-level `respond_to' feature now in `responders` gem as of rails 4.2
gem 'sass-rails', '~> 5.0' # use SCSS as CSS preprocessor

gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'turbolinks'

gem 'faraday'
gem 'simhash' # to compare mementos

gem 'phantomjs' # headless WebKit scriptable with a JavaScript API
gem 'uglifier' # js compression

gem 'assembly-image', '>= 1.7.4' # 1.7.3 has a potential issue with a rubocop autofix
gem 'fastimage'
gem 'mini_magick'

gem 'daemons' # ruby code can be run as daemon with simple start/stop/restart commands.
gem 'delayed_job_active_record'
gem 'whenever', require: false

gem 'config'
gem 'druid-tools'
# gem 'honeybadger', '~> 4.2' # for exception reporting
# See https://github.com/honeybadger-io/honeybadger-ruby/issues/369
gem 'honeybadger', github: 'honeybadger-io/honeybadger-ruby', branch: 'avoid-ar-connections'

gem 'okcomputer' # for 'upness' monitoring

group :development, :test do
  gem 'rubocop', '~> 0.53.0' # avoid code churn due to rubocop changes
  gem 'sqlite3'
end

group :development do
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'vcr'
  gem 'webmock'
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
