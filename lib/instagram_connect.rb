module InstagramConnect
  
  CLIENT_ID = "501ac1ddaa8743e1b9e6b90dc8b2454d"
  CLIENT_SECRET = "cc2196720df94ad082af68c929ccc47a"
  REDIRECT_URI = "http://saferconnect.heroku.com/instagram"

  module Helpers
    def self.included(base)
      Instagram.configure do |config|
        config.client_id = CLIENT_ID
        config.client_secret = CLIENT_SECRET
      end      
    end

    def instagram_authorize_url
      Instagram.authorize_url(:redirect_uri => REDIRECT_URI)
    end

    def instagram_access_token
      if session[:instagram_access_token].nil? && params[:code]
        resp = Instagram.get_access_token(params[:code], :redirect_uri => REDIRECT_URI)
        session[:instagram_access_token] = resp.access_token        
      end
      session[:instagram_access_token]
    end

    def instagram_access_token=(token)
      session[:instagram_access_token] = token
    end
  end

end
