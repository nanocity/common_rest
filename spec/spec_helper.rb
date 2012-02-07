require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'rspec/autorun'
require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start

require File.join( File.dirname( __FILE__ ), '..', 'lib/common_rest' )

# Set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

