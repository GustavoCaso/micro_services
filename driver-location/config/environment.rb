require 'rubygems'
require "bundler/setup"

require 'dotenv/load'
require 'sinatra'
require 'json'

# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

# load lib folder
Dir[APP_ROOT.join('lib', '**/*.rb')].each { |file| require file }
