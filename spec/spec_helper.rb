require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'development'
require File.expand_path("../../config/environment", __FILE__)

require 'coveralls'
Coveralls.wear!
