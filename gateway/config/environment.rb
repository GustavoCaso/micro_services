# Require gems we care about
require 'rubygems'
require "bundler/setup"

require 'dotenv/load'
require 'sinatra'
require 'yaml'
require 'json'

# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

# load lib folder
Dir[APP_ROOT.join('lib', '**/*.rb')].each { |file| require file }


# Let's create the endpoints provided by the yml file
route_builder = RouteBuilder.new(self)

YAML.load_file('config.yaml')['urls'].each do |url|
  route_builder.call(url)
end

