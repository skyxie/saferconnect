module FoursquareConnect

  CLIENT_ID = SERVICES[:foursquare][:id]
  CLIENT_SECRET = SERVICES[:foursquare][:secret]
  REDIRECT_URI = SERVICES[:foursquare][:redirect_uri]
  ACCESS_TOKEN_URI = "https://foursquare.com/oauth2/access_token"
  SELF_PROFILE_URI = "https://api.foursquare.com/v2/users/self"

  class << self

    def request_access_token(code)
      request_params = {
        :client_id => CLIENT_ID,
        :client_secret => CLIENT_SECRET,
        :grant_type => "authorization_code",
        :redirect_uri => REDIRECT_URI,
        :code => code
      }.inject([]) { |list,pair| list + [pair.join("=")] }.join("&")

      uri = URI.parse("#{ACCESS_TOKEN_URI}?#{request_params}")

      resp = http_request(uri)
      
      raise "Sorry, we could not authenticate" if resp.code !~ /20[0-9]/

      JSON.parse(resp.body)["access_token"]
    end
    
    def request_profile(token)
      uri = URI.parse("#{SELF_PROFILE_URI}?oauth_token=#{token}")
      resp = http_request(uri)
      raise resp if resp.code !~ /20[0-9]/
      JSON.parse(resp.body)["response"]
    end

    def http_request(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Get.new(uri.request_uri)
      http.request(req)
    end

  end

  module Helpers
    def foursquare_authorize_url
      "https://foursquare.com/oauth2/authenticate?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}"
    end

    def foursquare_access_token
      token = session[:foursquare_access_token]
      logger.debug "Foursquare access token pulled from session: #{token}"
      token
    end

    def set_foursquare_access_token(token)
      session[:foursquare_access_token] = token
      logger.debug "Setting Foursquare access token to: #{session[:foursquare_access_token]}"
    end

    def foursquare_profile
      @foursquare_profile ||= FoursquareConnect.request_profile(foursquare_access_token)
    end
  end
end
