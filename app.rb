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
# Response fields:
#
#   * `description`: A text description of the API state.
#
get '/' do
  status = ControlAPI.get('/v1/status')
  "API status: #{status['description']}"
end

# ## POST /v1/distributed_to_dos
#
# **Asynchronously** distribute a ToDo to the given assignees.
#
# Example request:
#
#     POST /v1/distributed_to_dos
#     template_to_do_uuid=12345678-1234-5678-1234-567812345678
#     assignee_emails=bobama@example.com,gwbush@example.com,bclinton@example.com
#     content={"field1":"value1"}
#
# Request fields:
#
#   * `template_to_do_uuid`: The UUID for the TemplateToDo that will be distributed.  This can be found in settings.
#   * `assignee_emails`: A comma separated list of emails of Users that will receive the DistributedToDos.
#   * `content`: JSON text of values to pre-fill in the DistributedToDo.  Field names are available under "Settings".
#
# Example response:
#
#   {"transaction_id":"f81d4fae-7dec-11d0-a765-00a0c91e6bf6"}
#
# Response fields:
#
#   * `transaction_id`: The UUID assigned to this request. Useful for troubleshooting.  Please include it in any bug reports to Continuity.
#
get '/distributed_to_dos/new' do
  # TODO: render form
end

post '/distributed_to_dos' do
  # TODO: receive POST from form and distribute as requested
end

# ## GET /v1/distributed_to_dos
#
# TODO
#
# Example response:
#
#     TODO
#
# Response fields:
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
# Response fields:
#
#   * TODO
#
