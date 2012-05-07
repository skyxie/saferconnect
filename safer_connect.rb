class SaferConnect < Sinatra::Base

  enable :sessions
  enable :logging
  set :root, File.dirname(__FILE__)
  set :session_secret, ENV['SESSION_KEY'] ||= 'skyxie_super_secret'

  use Rack::Logger, Logger::DEBUG

  helpers InstagramConnect::Helpers, FoursquareConnect::Helpers, Helpers

  get '/' do
    session[:counter] ||= 0
    session[:counter] += 1
    logger.debug "Session counter: #{session[:counter]}"
    erb :index
  end

  get '/foursquare' do
    token = FoursquareConnect.request_access_token(params[:code])
    logger.debug "Received Foursquare access_token : #{token}"
    set_foursquare_access_token(token)
    erb :index
  end

  get '/instagram' do
    token = InstagramConnect.request_access_token(params[:code])
    logger.debug "Received Instagram access_token : #{token}"
    set_instagram_access_token(token)
    erb :index
  end

  get '/map' do
    erb :map
  end

end
