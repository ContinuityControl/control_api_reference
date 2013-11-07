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
# ### Example request
#
#     GET /v1/status
#
# ### Example response
#
# #### HTTP 200 OK
#
#     {"description":"up"}
#
# #### HTTP 500 Server Error
#
# ### Response fields
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
# ### Example request
#
#     POST /v1/distributed_to_dos
#     template_to_do_api_id=12345678-1234-5678-1234-567812345678
#     assignee_emails=bobama@example.com,gwbush@example.com,bclinton@example.com,gbush@example.com
#     content={"field1":"value1"}
#
# ### Request fields
#
#   * `template_to_do_api_id`: **Required**.  The UUID for the TemplateToDo that will be distributed.  This can be found in settings.
#   * `assignee_emails`: **Required**.  A comma separated list of emails of Users that will receive the DistributedToDos.
#   * `content`: JSON text of values to pre-fill in the DistributedToDo.  Field names are available under "Settings".
#
# ### Example responses
#
# #### HTTP 201 Accepted
#
#   {"id":"123","path":"/v1/distributed_to_dos/123"}
#
# TODO: modify DistributedToDo so that it can provide the ID as above.
#
# #### HTTP 422 Unprocessable Entity
#
#   {"errors": {"assignee_emails": ["has invalid email address alice@example.com", "has invalid email address bob@example.com"]}}
#
# TODO: check what ActiveModel generates
#
# #### HTTP 500 Server Error
#
# ### Response fields
#
#   * `id`: The ID for the DistributedToDo that will be created asynchronously. Please include it in any bug reports to Continuity.
#   * `path`: The path where the DistributedToDo will be available.
#
get '/distributed_to_dos/new' do
  # TODO: render form
end

post '/distributed_to_dos' do
  # TODO: receive POST from form and distribute as requested
end

# ## /v1/distributed_to_dos/:id
#
# Get the current state of a distributed_to_do with the ID `:id`
#
# ### Example request
#
#     GET /v1/distributed_to_dos/4567
#
# ### Example response
#
# #### HTTP 200 OK
#
#     {
#       "id": "4567",
#       "created_at": "2013-11-02T12:34:46Z",
#       "completed_at": "2013-11-07T12:34:56Z",
#       "assignments": [
#         {
#           "user_email": "bobama@example.com",
#           "finished_on": "2013-11-07"
#         },
#         {
#           "user_email": "bclinton@example.com",
#           "finished_on": null
#         }
#       ]
#     }
#
# #### HTTP 500 Server Error
#
# ### Response fields
#
#   * `id`: Unique ID for this DistributedToDo. Not guaranteed to be numeric.
#   * `created_at`: ISO8601 datetime of the creation of this DistributedToDo, in UTC.
#   * `completed_at`: ISO8601 date of when the DistributedToDo was completed, in UTC.
#   * `assignments`: Array
#     * `user_email`: User email of DistributedToDo assignment
#     * `finished_on`: ISO8601 date on which the assignment was completed (in UTC), or `null` if not completed
#
get '/distributed_to_dos/:id' do
  # TODO: render a page with the information in the response
end

# ## GET /v1/distributed_to_dos
#
# Get all the distributed_to_dos for your organization.  Each DistributedToDo in this "index" GET request is in the same format as the "show" GET request.
#
# ### Example request
#
#     GET /v1/distributed_to_dos
#
# ### Example response
#
# #### HTTP 200 OK
#
#     {
#       "distributed_to_dos": [
#         // Content from GET /v1/distributed_to_dos/:id
#       ]
#     }
#
# #### HTTP 500 Server Error
#
# ### Response fields
#
#   * `distributed_to_dos`: an Array of DistributedToDos
#
get '/distributed_to_dos' do
  # TODO: render a page with links to each distributed_to_do
end
