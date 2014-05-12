require 'uri'
require 'json'
require 'platform_lib/service_base'

module PlatformLib
  # Public: A wrapper around the File Management Business Service
  #
  # Examples:
  #
  #     # the preferred method 
  #     service = PlatformLib::BusinessService.new("user", "pass").filemanagement_service
  #
  #     # direct instantiation
  #     service = PlatformLib::FileManagementService.new("auth_token")
  #
  class FilemanagementService
    include ServiceBase

    END_POINT = "https://fms.theplatform.com/web/FileManagement"
    
    # Public: Creates a new instance
    #
    # auth_token - the authentication token to be used
    def initialize(auth_token)
      @auth_token = auth_token
    end

    # Public: Resets the task end point
    #
    # params - an optional hash of parameters (query string)
    # block - an optional block to be called for each item returned
    #
    # Examples:
    #
    #     resetTask = filemanagement_service.resetTask(taskId, params)
    #
    #
    # Returns an empty response if successful
    def resetTask(taskId, params)
      data = { :resetTask => { :taskId => taskId } }
      post_data(END_POINT, params, data)
    end
  end
end