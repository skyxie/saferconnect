class SaferConnect < Sinatra::Base

  enable :sessions, :logging
  set :root, File.dirname(__FILE__)

  use Rack::Logger, Logger::DEBUG

  helpers InstagramConnect::Helpers, FoursquareConnect::Helpers, Helpers

  get '/' do
    erb :index
  end

  get '/foursquare' do
    token = FoursquareConnect.request_access_token(params[:code])
    logger.debug "Received Foursquare access_token : #{token}"
    foursquare_access_token = token
    erb :index
  end

  get '/instagram' do
    token = InstagramConnect.request_access_token(params[:code])
    logger.debug "Received Instagram access_token : #{token}"
    instagram_access_token = token
    erb :index
  end

  get '/map' do
    erb :map
  end

end
