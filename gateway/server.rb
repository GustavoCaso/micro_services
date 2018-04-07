# Require gems we care about
require 'rubygems'
require "bundler/setup"

require 'sinatra/cross_origin'
require 'sinatra'
require 'yaml'
require 'json'
require_relative 'lib/route_builder'

configure do
  enable :cross_origin
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

options '*' do
  response.headers['Access-Control-Allow-Methods'] = 'HEAD,GET,PUT,POST,DELETE,OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
  response.headers['Access-Control-Allow-Origin'] = '*'

  200
end

# Let's create the endpoints provided by the yml file

route_builder = RouteBuilder.new(self)

YAML.load_file('config.yaml')['urls'].each do |url|
  route_builder.call(url)
end
