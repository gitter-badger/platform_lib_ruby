require 'uri'
require 'json'
require 'platform_lib/service_base'

module PlatformLib
  # Public: A wrapper around the Media Data Service
  #
  # Examples:
  #
  #     service = PlatformLib::MediaService.new("user", "pass")
  #
  class MediaService
    include ServiceBase
    
    # Public: Creates a new instance of this service
    #
    # username - The username for use with basic auth
    # password - The password for use with basic auth
    def initialize(username, password)
      @username = username
      @password = password
    end

    # Public: Queries the Media endpoint
    #
    # params - a hash with all the (querystring) parameters
    # &block - an optional block to be executed for each media item returned
    #
    # Examples:
    #
    #     service = PlatformLib::MediaService.new(SOME_USER, SOME_PASSWORD)
    #
    #     results = service.query({ fields: "id,guid,title" })
    #
    #     service.query({ fields: "id,guid,title" }) do |media_item|
    #       puts "Title: #{media_item['title']}"
    #     end
    #
    # Returns the list of items (when block not supplied)
    def query(params, &block)
      with_authentication_token do |token|
        params[:token] = token if not token.strip.empty?

        items = execute_query(params)

        if block.nil?
          items
        else
          items.each { |item| block.call(item) }
        end
      end
    end

    # Public: Generates a query URL for the Media endpoint
    #
    # params - a hash of query string parameters
    #
    # Examples:
    #
    #     service = PlatformLib::MediaService.new(USER, PASS)
    #     puts service.query_url({ fields: "id,guid" })
    #
    # Returns the full url for the media service endpoint with the specified
    # query parameters
    def query_uri(params)
      url = "http://data.media.theplatform.com/media/data/Media"
      url << "?#{URI.encode_www_form(params)}" if params
      
      URI.parse(url)
    end

    private

    def execute_query(params)
      uri = query_uri(params)
      get_entries(uri)
    end
  end
end