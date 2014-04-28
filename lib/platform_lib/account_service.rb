require 'uri'
require 'json'
require 'platform_lib/service_base'

module PlatformLib
  # Public: A wrapper around the Account Data Service
  #
  # Examples:
  #
  #     # the preferred method 
  #     service = PlatformLib::DataService.new("user", "pass").account_service
  #
  #     # direct instantiation
  #     service = PlatformLib::AccountService.new("auth_token")
  #
  class AccountService
    include ServiceBase

    END_POINT = "https://mps.theplatform.com/data/Account"
    
    # Public: Creates a new instance
    #
    # auth_token - the authentication token to be used
    def initialize(auth_token)
      @auth_token = auth_token
    end

    # Public: Queries the account end point
    #
    # params - an optional hash of parameters (query string)
    # block - an optional block to be called for each item returned
    #
    # Examples:
    #
    #     items = account_service.get_account_items(range: "1-10")
    #
    #     account_service.get_account_items(byCustomValue: "{test}{val}") do |item|
    #       puts item.title
    #     end
    #
    # Returns the items supplied from the service
    def get_account_items(params = {}, &block)
      if block.nil?
        get_entries(END_POINT, params)      
      else
        get_entries(END_POINT, params, &block)
      end
    end
  end
end