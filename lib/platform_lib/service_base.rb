require 'json'
require 'net/https'

module PlatformLib
  # Public: Useful methods for working with thePlatform's
  # This module was intended to be mixed in
  #
  # Examples:
  #
  #     class MyClass
  #       include PlatformLib::ServiceBase
  #       ...
  #       ...
  #     end
  module ServiceBase

    # Public: Execute the supplied block passing a newly created 
    # auth token that can be used for subsequent requests.
    #
    # &block - the block to execute once the token has been obtained
    #
    # Examples:
    #
    #     with_authentication_token do |token|
    #       # do other things...
    #     end
    #
    # Returns nothing
    def with_authentication_token(&block)
      begin
        sign_in
        block.call(@auth_token)
      ensure
        sign_out if @auth_token
      end
    end

    protected

    attr_reader :username, :password

    # Executes the request and returns the result as a JSON object
    #
    # uri            - The full uri to download (not a string, rather a URI)
    # authentication - Optional flag indicating that basic auth should be used.
    #                  @username and @password will be used for auth.
    #                  The default is false.
    #
    # Examples:
    #
    #     url = "http://somedomain.com/item.json"
    #     json_object = get_json(URI.parse(url))
    #
    #     url = "http://some_secret_domain.com/item.json"
    #     json_object = get_json(URI.parse(url), true)
    #
    # Returns a JSON respresentation of the response from the server
    def get_json(uri, authenticate = false)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      req = Net::HTTP::Get.new(uri.request_uri)
      req.basic_auth(@username, @password) if authenticate
      
      res = http.request(req)
      JSON.parse(res.body)
    end

    private 

    AUTH_URL_FORMAT = "https://identity.auth.theplatform.com"
    AUTH_URL_FORMAT << "/idm/web/Authentication/ACTION?schema=1.0&form=json"

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