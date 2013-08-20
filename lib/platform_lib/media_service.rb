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
        params[:token] = token if token != ""

        items = execute_query(params)
        return items if block.nil?

        items.each { |item| block.call(item) }
      end
    end

    def query_uri(params)
      url = "http://data.media.theplatform.com/media/data/Media?"
      url << "#{URI.encode_www_form(params)}" if params
      
      URI.parse(url)
    end

    private

    def execute_query(params)
      uri = query_uri(params)
      puts "URL: #{uri}"
      get_json(uri)["entries"]
    end
  end
end