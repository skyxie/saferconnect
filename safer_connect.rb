class SaferConnect < Sinatra::Base

  enable :sessions, :logging
  set :root, File.dirname(__FILE__)

  use Rack::Logger, Logger::DEBUG

  helpers InstagramConnect::Helpers, FoursquareConnect::Helpers, Helpers

  get '/' do
    erb :index
  end

  get '/foursquare' do
    erb :index
  end

  get '/instagram' do
    erb :index
  end

  get '/map' do
    erb :map
  end

end
