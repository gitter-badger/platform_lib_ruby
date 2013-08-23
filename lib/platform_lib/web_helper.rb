require "net/https"

module PlatformLib
  module WebHelper

    def self.get(uri, auth)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == "https"
        http.use_ssl = true
      end

      request = Net::HTTP::Get.new(uri.request_uri)
      set_auth(request, auth)

      response = http.request(request)
      if block_given?
        yield(response.body)
      else
        response.body
      end
    end

    def self.put(uri, body)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == "https"
        http.use_ssl = true
      end

      request = Net::HTTP::Put.new(uri.request_uri)
      request.content_type = "application/json"
      request.body = body
      
      res = http.request(request)
      puts res.body
    end

    private

    def self.set_auth(request, auth)
      if auth.keys.include?(:user) and auth.keys.include?(:pass)
        request.basic_auth(auth[:user], auth[:pass])
      end
    end
  end
end