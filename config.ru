require 'rubygems'
require 'sinatra'
require './safer_connect.rb'
require 'thin'

run SaferConnect
