require 'rubygems'
require 'sinatra'
require 'thin'

require 'json'
require 'uri'
require 'uri/http'
require 'uri/https'
require 'net/http'
require 'net/https'
require 'instagram'

require 'redis'

require './lib/foursquare_connect.rb'
require './lib/instagram_connect.rb'
require './lib/helpers.rb'
require './safer_connect.rb'

$stdout.sync = true

$redis = if ENV['REDISTOGO_URL']
  redis_uri = URI.parse(ENV['REDISTOGO_URL'])
  Redis.new(:username => redis_uri.user,
            :password => redis_uri.password,
                :host => redis_uri.host,
                :port => redis_uri.port)
else
  Redis.new() # default connection
end 
