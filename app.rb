require 'sinatra'
require 'sinatra/reloader' if development?
require 'httparty'

class ControlAPI
  include HTTParty
  base_uri ENV['CONTROL_API_BASE_URI']
end

get '/' do
  api_status = ControlAPI.get("/v1/api_status")
  "API Status: #{api_status['status']}"
end
