require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
abort("The Rails app is running in production mode!") if Rails.env.production?
require "rspec/rails"
