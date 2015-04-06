# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'rake'
require 'bundler'

require 'rspec/core/rake_task'
require 'yard'
require 'yard/rake/yardoc_task'

# Executed by the following command 
# cd /opt/app/was/was-thumbnail-service/current && bundle exec rake RAILS_ENV=development was_thumbnail_service:run_thumbnail_monitor
namespace :was_thumbnail_service do
  task run_thumbnail_monitor: :environment do
    puts "Check if there are new mementos added to SWAP"
    Was::ThumbnailService::Monitor.run
  end
end

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

task :default => :ci  

desc "run continuous integration suite (tests, coverage, docs)" 
task :ci => [:rspec, :doc]

task :spec => :rspec

RSpec::Core::RakeTask.new(:rspec) do |spec|
  spec.rspec_opts = ["-c", "-f progress", "--tty", "-r ./spec/spec_helper.rb"]
end

# Use yard to build docs
begin
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