module InstagramConnect
  
  CLIENT_ID = SERVICES[:instagram][:id]
  CLIENT_SECRET = SERVICES[:instagram][:secret]
  REDIRECT_URI = SERVICES[:instagram][:redirect_uri]

  class << self
    def request_access_token(code)
      Instagram.configure do |config|
        config.client_id = CLIENT_ID
        config.client_secret = CLIENT_SECRET
      end      
      resp = Instagram.get_access_token(code, :redirect_uri => REDIRECT_URI)
      resp.access_token
    end

    def user_media_feed(access_token, user_id = nil)
      Instagram.configure do |config|
        config.client_id = CLIENT_ID
        config.access_token = access_token
      end

      if user_id
        Instagram.user_recent_media(user_id)
      else
        Instagram.user_media_feed
      end
    end

    def user(access_token)
      Instagram.configure do |config|
        config.client_id = CLIENT_ID
        config.access_token = access_token
      end

      Instagram.client.user
    end
  end

  module Helpers
    def instagram_authorize_url
      Instagram.configure do |config|
        config.client_id = CLIENT_ID
        config.client_secret = CLIENT_SECRET
      end      
      Instagram.authorize_url(:redirect_uri => REDIRECT_URI)
    end

    def instagram_access_token
      token = session[:instagram_access_token]
      logger.debug "Instagram access token pulled from session: #{token}"
      token
    end

    def set_instagram_access_token(token)
      session[:instagram_access_token] = token
      logger.debug "Setting Instagram access token to: #{session[:instagram_access_token]}"
    end
  end

end
