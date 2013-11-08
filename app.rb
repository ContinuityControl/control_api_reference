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
# TODO: diagram and explanation of User, TemplateToDo, DistributedToDo, and Assignment

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
#     assignee_emails=bobama@example.com,gwbush@example.com,bclinton@example.com,gbush@example.com,rreagan@example.com,jcarter@example.com,gford@example.com,rnixon@example.com
#     content={"field1":"value1"}
#
# ### Request fields
#
#   * `template_to_do_api_id`: **Required**.  The UUID for the TemplateToDo that will be distributed.  This can be found in settings.
#   * `assignee_emails`: **Required**.  A comma separated list of emails of Users that will receive the DistributedToDos.
#   * `content`: JSON text of values to pre-fill in the DistributedToDo.  Field names are available under "Settings".
#
# TODO: `assignee_emails` should be whatever gets parsed into an Array natively (e.g. `assignee_emails[]`)
#
# ### Example responses
#
# #### HTTP 202 Accepted
#
#     {
#       "id":"f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
#       "path":"/v1/distributed_to_dos/f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
#     }
#
# #### HTTP 422 Unprocessable Entity
#
#     {
#       "errors": {
#         "assignee_emails": [
#           "has invalid email address alice@example.com",
#           "has invalid email address bob@example.com"
#         ]
#       }
#     }
#
# TODO: check what ActiveModel generates
# TODO: Create users if they don't exist?
#
# #### HTTP 500 Server Error
#
# ### Response fields
#
#   * `id`: An ID for the DistributedToDo which will be created asynchronously. Please include it in any bug reports to Continuity.
#   * `path`: The path where the DistributedToDo will be available.
#   * `errors`: An object with one key per request field and an array of all the validation errors that apply to that field.
#
get '/distributed_to_dos/new' do
  # TODO: render form
  # TODO: Look into datomic
end

post '/distributed_to_dos' do
  # TODO: receive POST from form and distribute as requested
end

# ## /v1/distributed_to_dos/:id
#
# Get the current state of a distributed_to_do as found by an `id`.
#
# ### Example requests
#
#     GET /v1/distributed_to_dos/f81d4fae-7dec-11d0-a765-00a0c91e6bf6
#
# ### Example response
#
# #### HTTP 200 OK
#
#     {
#       "id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
#       "created_at": "2013-11-02T12:34:46Z",
#       "completed_at": "2013-11-07T12:34:56Z",
#       "due_on": "2013-11-08",
#       "assignments": [
#         {
#           "email": "bobama@example.com",
#           "finished_on": "2013-11-07"
#         },
#         {
#           "email": "bclinton@example.com",
#           "finished_on": null
#         }
#       ]
#     }
#
# #### HTTP 500 Server Error
#
# ### Response fields
#
#   * `id`: Unique ID for this DistributedToDo.
#   * `created_at`: ISO8601 datetime of the creation of this DistributedToDo, in UTC.
#   * `completed_at`: ISO8601 date of when the DistributedToDo was completed, in UTC.
#   * `due_on`: ISO8601 date of when the DistributedToDo is due, in UTC.
#   * `assignments`: Array
#     * `email`: User email of DistributedToDo assignment
#     * `finished_on`: ISO8601 date on which the assignment was completed (in UTC), or `null` if not completed
#
# TODO: make sure all DistributedToDos have a UUID-style `id`.
#
get '/distributed_to_dos/:id' do
  # TODO: render a page with the information in the response
end

# ## GET /v1/distributed_to_dos
#
# Get all the DistributedToDos for your organization.  Each DistributedToDo in this "collection" GET request is in the same format as the "member" GET request.
#
# ### Example requests
#
#     GET /v1/distributed_to_dos
#     GET /v1/distributed_to_dos?created_start_at=2013-11-02T12:34:46Z
#     GET /v1/distributed_to_dos?created_start_at=2013-11-02T12:34:46Z&created_finish_at=2013-11-07T12:34:46Z
#     GET /v1/distributed_to_dos?created_finish_at=2013-11-07T12:34:46Z
#     GET /v1/distributed_to_dos?late=true
#     GET /v1/distributed_to_dos?complete=true
#     GET /v1/distributed_to_dos?created_start_at=2013-11-02T12:34:46Z&created_finish_at=2013-11-07T12:34:46Z&late=true&complete=false
#
# ### Request fields
#
#   * `created_start_at`: ISO8601 datetime (in UTC) of inclusive lower bound of `created_at` time.
#   * `created_finish_at`: ISO8601 datetime (in UTC) of inclusive upper bound of `created_at` time.
#   * `late`: When `true`, respond with only "late" DistributedToDos.  When `false`, respond with only "on time" DistributedToDos.  When not present, do not filter on lateness.
#   * `complete`: When `true`, respond with only "complete" DistributedToDos.  When `false`, respond with only "incomplete" DistributedToDos.  When not present, do not filter on completeness.
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
