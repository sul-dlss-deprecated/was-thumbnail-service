# This file is copied to spec/ when you run 'rails generate rspec:install'
require File.expand_path("../../config/environment", __FILE__)

require 'coveralls'
Coveralls.wear!
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
  Coveralls::SimpleCov::Formatter
]

require 'vcr'
VCR.configure do |config|
  config.ignore_hosts 'codeclimate.com'
end
