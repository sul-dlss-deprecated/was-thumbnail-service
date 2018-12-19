# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('config/application', __dir__)

Rails.application.load_tasks

require 'rake'
require 'bundler'

# Executed by the following command
# cd /opt/app/was/was-thumbnail-service/current && bundle exec rake RAILS_ENV=production was_thumbnail_service:run_thumbnail_monitor
namespace :was_thumbnail_service do
  task run_thumbnail_monitor: :environment do
    Was::ThumbnailService::Monitor.run
    File.open('log/run_thumbnail_monitor.log', 'a') { |f| f.write("Check for new mementos to be added to SWAP at #{Time.current}\n") }
  end

  task install_phantomJS: :environment do
    puts 'Ensure PhantomJS is installed'
    Phantomjs.path
  end
end

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

begin
  require 'rspec/core/rake_task'

  desc 'Run RSpec tests'
  RSpec::Core::RakeTask.new(:spec)

  desc 'Run RSpec tests except those that require mysql'
  RSpec::Core::RakeTask.new(:spec_sqlite) do |t|
    t.rspec_opts = ['-t ~@mysql']
  end
rescue LoadError
  # should only get here on production system, and we don't care in that context
  warn 'RSpec could not run'
end

begin
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new(:rubocop)
rescue LoadError
  # should only get here on production system, and we don't care in that context
  warn 'RuboCop could not run'
end

desc 'run continuous integration suite (tests, coverage, rubocop)'
task ci: %i[rubocop spec]

# clear the default task injected by rspec
task(:default).clear

# and replace it with our own
task default: :ci
