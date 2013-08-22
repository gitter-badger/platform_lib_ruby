require 'json'
require 'hashie'
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

    def get_item(uri, use_basic_auth = false)
      perform_request(uri, use_basic_auth) do |response|
        Hashie::Mash.new(JSON.parse(response.body))
      end
    end

    def get_entries(uri, use_basic_auth = false)
      perform_request(uri, use_basic_auth) do |response|
        array = JSON.parse(response.body)["entries"]
        array.map { |entry| Hashie::Mash.new(entry) }
      end
    end

    private 

    AUTH_URL_FORMAT = "https://identity.auth.theplatform.com"
    AUTH_URL_FORMAT << "/idm/web/Authentication/ACTION?schema=1.0&form=json"

    def perform_request(uri, use_basic_auth)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(@username, @password) if use_basic_auth

      response = http.request(request)

      if block_given?
        yield(response)
      else
        response
      end
    end

    def sign_in
      url = "#{AUTH_URL_FORMAT.sub(/ACTION/, 'signIn')}"

      value = get_item(URI.parse(url), true)
      @auth_token = value.signInResponse.token
    end

    def sign_out
      url = "#{AUTH_URL_FORMAT.sub(/ACTION/, 'signOut')}"
      url << "&_token=#{@auth_token}"
      get_item(URI.parse(url))
    end

  end
end