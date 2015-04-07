#require 'webmock/rspec'


# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'development'
require File.expand_path("../../config/environment", __FILE__)

require 'coveralls'
Coveralls.wear!

#WebMock.disable_net_connect!(allow_localhost: true)
# whitelist codeclimate.com so test coverage can be reported
#Rails.configuration.after(:suite) do
 # WebMock.disable_net_connect!(:allow => 'codeclimate.com')
#end