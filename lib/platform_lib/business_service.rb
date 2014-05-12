require "json"
require "hashie"
require "platform_lib/web_helper"

module PlatformLib
  class BusinessService
    
    def initialize(username, password)
      @username = username
      @password = password
      @auth_token = nil

      @services = {}
    end

    def method_missing(method_name, *args)
      if method_name =~ /^(.*)_service$/
        service_by_name($1)
      else
        super
      end
    end

    def sign_out
      return if @auth_token.nil?
      
      url = AUTH_URL_FORMAT.sub(/ACTION/, 'signOut')
      url << "&_token=#{@auth_token}"
      uri = URI.parse(url)

      response = WebHelper::get(uri, :user => @username, :pass => @password)
      @auth_token = nil
      @services.clear
    end

    private 

    AUTH_URL_FORMAT = "https://identity.auth.theplatform.com"
    AUTH_URL_FORMAT << "/idm/web/Authentication/ACTION?schema=1.0&form=json"

    def service_by_name(name)
      
      # we've already got an instance
      service = @services[name]

      if service.nil?
        # create a new service
        sign_in

        class_name = "#{name.capitalize}Service"
        service = PlatformLib.const_get(class_name).new(@auth_token)
        @services[name] = service
      end

      if block_given?
        yield(service)
      else
        service
      end
    end  

    def sign_in
      uri = URI.parse(AUTH_URL_FORMAT.sub(/ACTION/, 'signIn'))
      response = WebHelper::get(uri, user: @username, pass: @password)

      response_object = Hashie::Mash.new(JSON.parse(response))
      @auth_token = response_object.signInResponse.token
    end
  end
end