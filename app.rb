# # Continuity Control API Documentation
#
# This file is automatically generated from the code publically available on [GitHub](https://github.com/ContinuityControl/control_api_reference).
#
# TODO: add diagram and explanation of User, TemplateToDo, DistributedToDo, and Assignment
# 
# ---
#
# This is a [Sinatra](http://www.sinatrarb.com/) application that integrates with the Control API.  Sinatra is a small Ruby web application framework that provides a DSL (domain specific language) for handling HTTP requests like `get` and `post`.  It should be easy to read even if you don't read Sinatra's documentation.
require 'sinatra'
require 'sinatra/reloader' if development?
require 'httparty'
require 'dotenv'
Dotenv.load

# Log configuration for debugging purposes.
puts
puts 'Environment'
puts "CONTROL_API_BASE_URI=#{ENV['CONTROL_API_BASE_URI']}"
puts

# This class uses a library called `HTTParty` to connect to the Control API.  In general, all API responses are JSON.  `HTTParty` automatically detects this and parses into a Ruby object.
#
# For more information, see the [HTTParty](http://johnnunemaker.com/httparty/) website.
class ControlAPI
  include HTTParty
  base_uri ENV['CONTROL_API_BASE_URI']
end

# The root path in this application simply provides navigation.
get '/' do
  erb :root
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
get '/status' do
  status = ControlAPI.get('/v1/status').parsed_response
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
#     assignee_emails=["bobama@example.com","gwbush@example.com","bclinton@example.com","gbush@example.com","rreagan@example.com","jcarter@example.com","gford@example.com","rnixon@example.com"]
#     content={"field1":"value1"}
#
# ### Request fields
#
#   * `template_to_do_api_id`: **Required**.  The UUID for the TemplateToDo that will be distributed.  This can be found in settings.
#   * `assignee_emails`: **Required**.  A JSON Array of email addresses of Users that will receive the DistributedToDos.
#   * `content`: JSON text of values to pre-fill in the DistributedToDo.  Field names are available under "Settings".
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
  erb :distributed_to_dos_new
end

post '/distributed_to_dos' do
  distributed_to_do = ControlAPI.post('/v1/distributed_to_dos', params)

  case distributed_to_do.response.code
  when '202'
    [200, erb(:distributed_to_dos_post, :locals => distributed_to_do)]
  when '422'
    [422, erb(:distributed_to_dos_errors, :locals => distributed_to_do)]
  else 
    [500, 'There was an error while processing your request']
  end
end

# ## GET /v1/distributed_to_dos/:id
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
# #### HTTP 404 Not Found
#
# Returned when the resource does not exist.  Note that after a `POST` to `/v1/distributed_to_dos` that gives a `202`, `/v1/distributed_to_dos/:id` would return a `404` until the resource is **asynchronously** created.
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
  distributed_to_do = ControlAPI.get("/v1/distributed_to_dos/#{params[:id]}")

  case distributed_to_do.response.code
  when '200'
    erb :distributed_to_do, :locals => distributed_to_do
  when '404'
    [404, 'Not found']
  else 
    [500, 'There was an error while processing your request']
  end
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
#   * `distributed_to_dos`: an Array of DistributedToDos, or an empty array `[]` if none match the given criteria
#
get '/distributed_to_dos' do
  distributed_to_dos = ControlAPI.get('/v1/distributed_to_dos')
  erb :distributed_to_dos, :locals => distributed_to_dos
end
