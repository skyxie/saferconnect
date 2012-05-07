module FoursquareConnect

  CLIENT_ID = "TISG2M1FXGO1RZUECP1MNU5RFOICFGYMB1BIUVIRJRH5BANH"
  CLIENT_SECRET = "XPSQ4W3GSWSUW1QW44NYBS550EOVCKV3B0XA4QFB2WMIGI0P"
  REDIRECT_URI = "http://saferconnect.heroku.com/foursquare"
  ACCESS_TOKEN_URI = "https://foursquare.com/oauth2/access_token"

  module Helpers
    def foursquare_authorize_url
      "https://foursquare.com/oauth2/authenticate?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}"
    end

    def foursquare_access_token
      if session[:foursquare_access_token].nil? && params[:code]
        logger.debug "Received code #{params[:code]}"
        request_params = {
          :client_id => CLIENT_ID,
          :client_secret => CLIENT_SECRET,
          :grant_type => "authorization_code",
          :redirect_uri => REDIRECT_URI,
          :code => params[:code]
        }.inject([]) { |list,pair| list + [pair.join("=")] }.join("&")
        logger.debug "Sending request params #{request_params}"

        uri = URI.parse("#{ACCESS_TOKEN_URI}?#{request_params}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        req = Net::HTTP::Get.new(uri.request_uri)
        resp = http.request(req)
        logger.debug "Received response code: #{resp.code} with body: #{resp.body}"
        
        raise "Sorry, we could not authenticate" if resp.code !~ /20[0-9]/

        session[:foursquare_access_token] = JSON.parse(resp.body)["access_token"]
      end
      session[:foursquare_access_token]
    end

    def foursquare_access_token=(token)
      session[:foursquare_access_token] = token
    end
  end
end
