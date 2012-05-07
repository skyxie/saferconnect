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

require './lib/foursquare_connect.rb'
require './lib/instagram_connect.rb'
require './lib/helpers.rb'
require './safer_connect.rb'

$stdout.sync = true
