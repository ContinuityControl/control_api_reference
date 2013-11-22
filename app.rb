# # Continuity Control API Documentation
#
# This file is automatically generated from the code publically available on [GitHub](https://github.com/ContinuityControl/control_api_reference).
#
# ---
#
# This is a [Sinatra](http://www.sinatrarb.com/) application that integrates with the Control API.  Sinatra is a small Ruby web application framework that provides a DSL (domain specific language) for handling HTTP requests like `get` and `post`.  It should be easy to read even if you don't read Sinatra's documentation.
require 'sinatra'
require 'sinatra/reloader' if development?
require 'httparty'
require 'json'
require 'dotenv'
Dotenv.load

# This class uses a library called HTTParty to connect to the Control API.  All API responses are JSON.  `HTTParty` automatically detects this and parses into a Ruby object.
#
# For more information, see the [HTTParty](http://johnnunemaker.com/httparty/) website.
class ControlAPI
  include HTTParty
  base_uri ENV['CONTROL_API_BASE_URI']

  basic_auth ENV['CONTROL_API_KEY'], ENV['CONTROL_API_SECRET']
end

# The root path in this application simply provides navigation.
#
# `erb :view_name` renders the file in `views/view_name.erb`.  For example, this will end up rendering `views/root.erb`.
get '/' do
  erb :root
end

# ## GET /v1/status.json
#
# Check the API status.  Useful for testing authentication without knowing other information.
#
# ### Example request
#
#     GET /v1/status.json
#
# ### Example response
#
# #### HTTP 200 OK
#
#     {"description":"up"}
#
# #### HTTP 401 Unauthorized
#
# The request was not properly authenticated.
#
# #### HTTP 500 Server Error
#
# ### Response fields
#
#   * `description`: A text description of the API state.
#
get '/status' do
  status = ControlAPI.get('/v1/status.json').parsed_response
  "API status: #{status['description']}"
end

# ## POST /v1/distributed_to_dos.json
#
# **Asynchronously** distribute a ToDo to the given assignees.  (The work happens in a job queue.)
#
# ### Example request
#
#     POST /v1/distributed_to_dos.json
#     Content-Type: application/json
#
#     {
#       "distributed_to_do": {
#         "template_to_do_uuid": "12345678-1234-5678-1234-567812345678",
#         "due_on": "2013-11-29",
#         "assignee_emails": ["bobama@example.com", "gwbush@example.com", "bclinton@example.com"],
#         "field_values": {"field1": "value1", "field2": "value2"}
#       }
#     }
#
# ### Request fields
#
#   * `distributed_to_do`: **Required**.  Holds parameters for the DistributedToDo.
#     * `template_to_do_uuid`: **Required**.  The UUID for the TemplateToDo that will be distributed.  This can be found in Continuity Control under "Settings".
#     * `due_on`: **Required**.  ISO8601 date of when the DistributedToDo is due, in UTC.
#     * `assignee_emails`: **Required**.  An Array of email addresses of Users that will receive the DistributedToDos.
#     * `field_values`: Dictionary (Object) of values to pre-fill in the DistributedToDo.  Field names are available in Continuity Control under "Settings".
#
# ### Example responses
#
# #### HTTP 202 Accepted
#
#     {
#       "uuid":"f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
#       "path":"/v1/distributed_to_dos/f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
#     }
#
# #### HTTP 401 Unauthorized
#
# The request was not properly authenticated.
#
# #### HTTP 422 Unprocessable Entity
#
#     {
#       "errors": {
#         "template_to_do_id": [
#           "does not exist",
#         ],
#         "assignee_emails": [
#           "has email alice@example.com which does not exist for this organization",
#           "has email bob@example.com which does not exist for this organization"
#         ],
#         "due_on": [
#           "could not be parsed"
#         ]
#       }
#     }
#
# #### HTTP 500 Server Error
#
# ### Response fields
#
#   * `uuid`: An UUID for the DistributedToDo which will be created asynchronously. Please include it in any bug reports to Continuity.
#   * `path`: The path where the DistributedToDo will be available once created.
#   * `errors`: An object with one key per request field and an array of all the validation errors that apply to that field.  The exact text of the error messages **is not** guaranteed and may change without warning.
#
get '/distributed_to_dos/new' do
  erb :distributed_to_dos_new
end

post '/distributed_to_dos' do
  distributed_to_do = ControlAPI.post('/v1/distributed_to_dos.json',
                                      :body => params.to_json,
                                      :headers => { 'Content-Type' => 'application/json' })

  case distributed_to_do.response.code
  when '202'
    [200, erb(:distributed_to_dos_post, :locals => distributed_to_do)]
  when '422'
    [422, erb(:distributed_to_dos_errors, :locals => distributed_to_do)]
  else
    [500, 'There was an error while processing your request']
  end
end

# ## GET /v1/distributed_to_dos/:uuid.json
#
# Get the current state of a distributed_to_do as found by an `uuid`.
#
# ### Example requests
#
#     GET /v1/distributed_to_dos/f81d4fae-7dec-11d0-a765-00a0c91e6bf6.json
#
# ### Example response
#
# #### HTTP 200 OK
#
#     {
#       "uuid": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6",
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
# #### HTTP 401 Unauthorized
#
# The request was not properly authenticated.
#
# #### HTTP 404 Not Found
#
# Returned when the resource does not exist.  Note that after a `POST` to `/v1/distributed_to_dos.json` that gives a `202`, `/v1/distributed_to_dos/:uuid.json` would return a `404` until the resource is **asynchronously** created.
#
# #### HTTP 500 Server Error
#
# ### Response fields
#
#   * `uuid`: UUID for this DistributedToDo.
#   * `created_at`: ISO8601 datetime of the creation of this DistributedToDo, in UTC.
#   * `completed_at`: ISO8601 datetime of when the DistributedToDo was completed, in UTC.  This is when all the assignments have been finished.
#   * `due_on`: ISO8601 date of when the DistributedToDo is due, in UTC.
#   * `assignments`: Array
#     * `email`: User email of DistributedToDo assignment
#     * `completed_on`: ISO8601 date on which the assignment was completed (in UTC), or `null` if not completed
#
get '/distributed_to_dos/:uuid' do
  distributed_to_do = ControlAPI.get("/v1/distributed_to_dos/#{params[:uuid]}.json")

  case distributed_to_do.response.code
  when '200'
    erb :distributed_to_do, :locals => distributed_to_do
  when '404'
    [404, 'Not found']
  else
    [500, 'There was an error while processing your request']
  end
end

# ## GET /v1/distributed_to_dos.json
#
# Get all the DistributedToDos for your organization.  Each DistributedToDo in this "collection" GET request is in the same format as the "member" GET request.
#
# ### Example requests
#
#     GET /v1/distributed_to_dos.json
#     GET /v1/distributed_to_dos.json?created_after=2013-11-02T12:34:46Z
#     GET /v1/distributed_to_dos.json?created_after=2013-11-02T12:34:46Z&created_before=2013-11-07T12:34:46Z
#     GET /v1/distributed_to_dos.json?created_before=2013-11-07T12:34:46Z
#     GET /v1/distributed_to_dos.json?late=true
#     GET /v1/distributed_to_dos.json?complete=true
#     GET /v1/distributed_to_dos.json?created_after=2013-11-02T12:34:46Z&created_before=2013-11-07T12:34:46Z&late=true&complete=false
#
# ### Request fields
#
#   * `created_after`: ISO8601 datetime (in UTC) of inclusive lower bound of `created_at` time.
#   * `created_before`: ISO8601 datetime (in UTC) of inclusive upper bound of `created_at` time.
#   * `late`: When `true`, respond with only "late" DistributedToDos.  When `false`, respond with only "on time" DistributedToDos.  When not present, do not filter on lateness.
#   * `complete`: When `true`, respond with only "complete" DistributedToDos.  When `false`, respond with only "incomplete" DistributedToDos.  When not present, do not filter on completeness.
#
# `late` and `complete` can be combined to filter:
#
#     late=false&complete=false  # incomplete and on time
#     late=false&complete=true   # completed and on time
#     late=true&complete=false   # incomplete and late (what most users will want)
#     late=true&complete=true    # completed and late
#
# ### Example response
#
# #### HTTP 200 OK
#
#     {
#       "distributed_to_dos": [
#         // Content from GET /v1/distributed_to_dos/:uuid
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
  distributed_to_dos = ControlAPI.get('/v1/distributed_to_dos.json', :query => params)
  erb :distributed_to_dos, :locals => distributed_to_dos
end
