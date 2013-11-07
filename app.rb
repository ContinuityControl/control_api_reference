require 'sinatra'
require 'sinatra/reloader' if development?
require 'httparty'
require 'dotenv'
Dotenv.load

puts
puts 'Environment'
puts "CONTROL_API_BASE_URI=#{ENV['CONTROL_API_BASE_URI']}"
puts

# # API Documentation
#
# This class uses a library called `HTTParty` to connect to the Control API.  In general, all API responses are JSON.  `HTTParty` automatically detects this and parses into a Ruby object.
class ControlAPI
  include HTTParty
  base_uri ENV['CONTROL_API_BASE_URI']
end

# ## GET /v1/status
#
# Check the API status.  Useful for testing authentication without knowing other information.
#
# Example response:
#
#     {"description":"up"}
#
# Fields:
#
#   * `description`: a text description of the API state
#
get '/' do
  status = ControlAPI.get('/v1/status')
  "API status: #{status['description']}"
end

# ## POST /v1/distributed_to_dos
#
# TODO
#
# Request:
#
#   * TODO
#
# Example response:
#
#     TODO
#
# Fields:
#
#   * TODO
#

# ## GET /v1/distributed_to_dos
#
# TODO
#
# Example response:
#
#     TODO
#
# Fields:
#
#   * TODO
#

# ## /v1/distributed_to_dos/:id
#
# TODO
#
# Example response:
#
#     TODO
#
# Fields:
#
#   * TODO
#
