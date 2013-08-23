require 'uri'
require 'json'
require 'platform_lib/service_base'

module PlatformLib
  # Public: A wrapper around the Media Data Service
  #
  # Examples:
  #
  #     # the preferred method 
  #     service = PlatformLib::DataService.new("user", "pass").media_service
  #
  #     # direct instantiation
  #     service = PlatformLib::MediaService.new("auth_token")
  #
  class MediaService
    include ServiceBase

    END_POINT = "http://data.media.theplatform.com/media/data/Media"
    
    # Public: Creates a new instance
    #
    # auth_token - the authentication token to be used
    def initialize(auth_token)
      @auth_token = auth_token
    end

    # Public: Queries the media end point
    #
    # params - an optional hash of parameters (query string)
    # block - an optional block to be called for each item returned
    #
    # Examples:
    #
    #     items = media_service.get_media_items(range: "1-10")
    #
    #     media_service.get_media_items(byCustomValue: "{test}{val}") do |item|
    #       puts item.title
    #     end
    #
    # Returns the items supplied from the service
    def get_media_items(params = {}, &block)
      if block.nil?
        get_entries(END_POINT, params)      
      else
        get_entries(END_POINT, params, &block)
      end
    end

    # Public: Updates the supplied items and their properties using the 
    # PUT method
    #
    # items - an array of items to be updated
    # params - an optional hash of parameters (query string)
    #
    # Example:
    #
    #     items = [ { id: "id_value", guid: "guid_value" }, .. ]
    #     media_service.update_media_items(items)
    #
    def update_media_items(items, params)
      put_entries("#{END_POINT}/list", params, items)
    end
  end
end