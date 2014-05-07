require 'json'
require 'hashie'
require "platform_lib/web_helper"

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

    protected 

    # Protected: Performs a get request and returns the "entries" array
    #
    # end_point - the https? end point to connect to
    # params - an optional hash of parameter values (query string)
    # block - an optional block to be called for each returned entry
    #
    # Examples:
    #
    #     arr = get_entries("http://www.somedomain.com/service", { uid: 10 })
    #
    #     get_entries("http://www.domain.com") do |single_item|
    #       # do something with the item
    #     end
    def get_entries(end_point, params = {}, &block)
      ensure_auth_param(params)

      uri = URI.parse("#{end_point}?#{URI.encode_www_form(params)}")
      raw = WebHelper::get(uri, token: @auth_token)

      items = JSON.parse(raw)["entries"].map { |item| Hashie::Mash.new(item) }

      if block.nil?
        items
      else
        items.each { |item| block.call(item) }
      end
    end

    # Protected: Performs a put request, updating the entries
    #
    # end_point - the https? end point to connect to
    # params - an optional hash of parameter values (query string)
    # entries - the array of entries to be added to the request body
    #
    # Examples:
    #
    #     arr = get_entries("http://www.somedomain.com/service", { uid: 10 })
    #     put_entries(MY_END_POINT, nil, arr)
    def put_entries(end_point, params = {}, entries)
      ensure_auth_param(params)

      uri = URI.parse("#{end_point}?#{URI.encode_www_form(params)}")
      puts uri.to_s
      body = "{ \"entries\": #{JSON.generate(entries)} }"
      
      WebHelper::put(uri, body)
    end

    def post_data(end_point, params = {}, data)
      ensure_auth_param(params)

      uri = URI.parse("#{end_point}?#{URI.encode_www_form(params)}")
      puts uri.to_s
      body = "#{JSON.generate(data)}"

      WebHelper::post(uri, body)
    end


    private 

    def ensure_auth_param(params)
      # ensure the token parameter is there
      params[:token] = @auth_token if not params.has_key?(:token)
    end

  end
end