source 'https://rubygems.org'

gem 'rails', '~> 4.2.7'
gem 'responders' # controller-level `respond_to' feature now in `responders` gem as of rails 4.2
gem 'mysql2', '~> 0.3.21' # issue with Rails 4.1.x and 4.2.x https://github.com/rails/rails/issues/21544
gem 'sass-rails', '~> 4.0.5'  # use SCSS as CSS preprocessor

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

gem 'rest-client', '~> 1.8' # pinned to 1.x release line as 2.x breaks rake was_thumbnail_service:run_thumbnail_monitor
gem 'simhash' # to compare mementos

gem 'therubyracer' # embed the V8 JavaScript interpreter into Ruby
gem 'phantomjs' # headless WebKit scriptable with a JavaScript API
gem 'uglifier' # js compression

gem 'fastimage'
gem 'mini_magick'
gem 'assembly-image'

gem 'delayed_job_active_record'
gem 'daemons' # ruby code can be run as daemon with simple start/stop/restart commands.
gem 'whenever', :require => false

gem 'druid-tools'
gem 'honeybadger' # for exception reporting
gem 'okcomputer' # for 'upness' monitoring

group :development, :test do
  gem 'rubocop'
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
