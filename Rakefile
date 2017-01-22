# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'rake'
require 'bundler'

# Executed by the following command
# cd /opt/app/was/was-thumbnail-service/current && bundle exec rake RAILS_ENV=production was_thumbnail_service:run_thumbnail_monitor
namespace :was_thumbnail_service do
  task run_thumbnail_monitor: :environment do
    Was::ThumbnailService::Monitor.run
    File.open("log/run_thumbnail_monitor.log", 'a') { |f| f.write("Check for new mementos to be added to SWAP at #{Time.now}\n") }
  end

  task install_phantomJS: :environment do
    puts "Ensure PhatonmJS is installed"
    Phantomjs.path
  end
end

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

task default: :ci

desc "run continuous integration suite (tests, coverage, rubocop)"
task ci: [:spec, :rubocop]

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
end

begin
  require 'rubocop/rake_task'

  desc 'Run rubocop'
  task :rubocop do
    RuboCop::RakeTask.new
  end
rescue LoadError
  # should only get here on production system, and we don't care in that context
end

# Use yard to build docs
begin
  require 'yard'
  require 'yard/rake/yardoc_task'

  project_root = File.expand_path(File.dirname(__FILE__))
  doc_dest_dir = File.join(project_root, 'doc')

  YARD::Rake::YardocTask.new(:doc) do |yt|
    yt.files = Dir.glob(File.join(project_root, 'lib', '**', '*.rb')) +
                 [ File.join(project_root, 'README.rdoc') ]
    yt.options = ['--output-dir', doc_dest_dir, '--readme', 'README.rdoc', '--title', 'WAS Registrar Documentation']
  end
rescue LoadError
  desc "Generate YARD Documentation"
  task :doc do
    abort "Please install the YARD gem to generate rdoc."
  end
end
