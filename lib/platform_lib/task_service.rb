require 'uri'
require 'json'
require 'platform_lib/service_base'

module PlatformLib
  # Public: A wrapper around the Task Data Service
  #
  # Examples:
  #
  #     # the preferred method 
  #     service = PlatformLib::DataService.new("user", "pass").task_service
  #
  #     # direct instantiation
  #     service = PlatformLib::TaskService.new("auth_token")
  #
  class TaskService
    include ServiceBase

    END_POINT = "http://data.task.theplatform.com/task/data/Task"
    
    # Public: Creates a new instance
    #
    # auth_token - the authentication token to be used
    def initialize(auth_token)
      @auth_token = auth_token
    end

    # Public: Queries the task end point
    #
    # params - an optional hash of parameters (query string)
    # block - an optional block to be called for each item returned
    #
    # Examples:
    #
    #     items = task_service.get_task_items(range: "1-10")
    #
    #     task_service.get_task_items(byCustomValue: "{test}{val}") do |item|
    #       puts item.title
    #     end
    #
    # Returns the items supplied from the service
    def get_task_items(params = {}, &block)
      if block.nil?
        get_entries(END_POINT, params)      
      else
        get_entries(END_POINT, params, &block)
      end
    end
  end
end