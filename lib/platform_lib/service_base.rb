require 'json'
require 'net/https'

module PlatformLib
  module ServiceBase
    AUTH_URL_FORMAT = "https://identity.auth.theplatform.com"
    AUTH_URL_FORMAT << "/idm/web/Authentication/ACTION?schema=1.0&form=json"

    def with_authentication_token(&block)
      begin
        # create token
        sign_in
        block.call(@auth_token)
      ensure
        # destroy token
        sign_out if @auth_token
      end
    end

    protected

    attr_reader :username, :password

    def get_json(uri, authenticate = false)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.to_s.start_with?("https")
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      req = Net::HTTP::Get.new(uri.request_uri)
      req.basic_auth(@username, @password) if authenticate
      
      res = http.request(req)
      JSON.parse(res.body)
    end

    private 

    def sign_in
      url = "#{AUTH_URL_FORMAT.sub(/ACTION/, 'signIn')}"

      value = get_json(URI.parse(url), true)
      @auth_token = value["signInResponse"]["token"]
    end

    def sign_out
      url = "#{AUTH_URL_FORMAT.sub(/ACTION/, 'signOut')}"
      url << "&_token=#{@auth_token}"
      get_json(URI.parse(url))
    end

  end
end