source 'https://rubygems.org'

gem 'rails', '~> 4.1.16'
gem 'mysql2', '~> 0.3.21' # issue with Rails 4.1.x and 4.2.x https://github.com/rails/rails/issues/21544
gem 'sass-rails', '~> 4.0.5'  # use SCSS as CSS preprocessor
#gem 'coffee-rails', '~> 4.0.1'  # not used?  no coffee assets or views?
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

gem 'rest-client', '~> 1.8' # pinned to 1.x release line as 2.x breaks our code as-is
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
gem 'whenever', :require => false

gem 'druid-tools'
gem 'is_it_working-cbeer'

group :development, :test do
  gem 'rubocop'
  gem 'sqlite3'
end

group :development do
  gem 'spring'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'coveralls', require: false
  gem 'codeclimate-test-reporter', require: false
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
  gem 'sdoc'
  gem 'yard'
end
