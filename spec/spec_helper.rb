require "simplecov"
SimpleCov.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'development'
require File.expand_path("../../config/environment", __FILE__)

require 'coveralls'
Coveralls.wear!

VCR.configure do |config|
  config.ignore_hosts 'codeclimate.com'
end
