require 'uri'
require 'json'
require 'platform_lib/service_base'

module PlatformLib
  class MediaService
    include ServiceBase
    
    def initialize(username, password)
      @username = username
      @password = password
    end

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

    def query_uri(params)
      url = "http://data.media.theplatform.com/media/data/Media"
      url << "?#{URI.encode_www_form(params)}" if params
      
      URI.parse(url)
    end

    private

    def execute_query(params)
      uri = query_uri(params)
      response = get_json(uri)

      response["entries"]
    end
  end
end