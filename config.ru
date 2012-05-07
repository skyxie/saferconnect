require 'rubygems'
require 'sinatra'
require './safer_connect.rb'
require 'thin'

$stdout.sync = true
run SaferConnect
