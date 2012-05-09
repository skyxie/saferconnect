class SaferConnect < Sinatra::Base

  enable :sessions
  enable :logging
  set :root, File.dirname(__FILE__)
  set :session_secret, ENV['SESSION_KEY'] ||= 'skyxie_super_secret'

  use Rack::Logger, Logger::DEBUG

  helpers InstagramConnect::Helpers, FoursquareConnect::Helpers, Helpers

  get '/' do
    if instagram_access_token
      @instagram_user = InstagramConnect.user(instagram_access_token)
    end

    erb :index
  end

  get '/foursquare' do
    token = FoursquareConnect.request_access_token(params[:code])
    logger.debug "Received Foursquare access_token : #{token}"
    $redis.sadd("foursquare:tokens", token)
    set_foursquare_access_token(token)
    redirect '/'
  end

  get '/instagram' do
    token = InstagramConnect.request_access_token(params[:code])
    logger.debug "Received Instagram access_token : #{token}"
    $redis.sadd("instagram:tokens", token)
    set_instagram_access_token(token)
    redirect '/'
  end

  get '/map' do
    erb :map
  end

  get '/instagram/feed' do
    if instagram_access_token.nil?
      redirect '/'
    end

    @user_media_feed = InstagramConnect.user_media_feed(instagram_access_token).data
    erb :instagram_feed
  end

  get '/instagram/:user_id/feed' do
    if instagram_access_token.nil?
      redirect '/'
    end

    @user_media_feed = InstagramConnect.user_media_feed(instagram_access_token, params[:user_id])
    erb :instagram_feed
  end

  # my little secret
  get '/:service/tokens' do
    content_type :json
    $redis.smembers("#{params[:service]}:tokens").to_json
  end

end
