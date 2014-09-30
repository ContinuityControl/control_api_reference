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

helpers do
  def parsed_body
    request.body.rewind
    ::JSON.parse(request.body.read)
  end
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
#   * `error`: A text description of any error in the API call.
#
get '/status' do
  status = ControlAPI.get('/v1/status.json').parsed_response

  if status['error']
    "API error: #{status['error']}"
  else
    "API status: #{status['description']}"
  end
end

# ## GET /v1/users/:uuid.json
#
# (currently in development)
#
# Get an individual user by its id
#
# #### Data Example
#
#     {
#       "uuid": "85a95390-4814-11e4-916c-0800200c9a66",
#       "email": "gwashington@example.com",
#       "full_name": "George Washington",
#       "first_name": "George",
#       "last_name": "Washington",
#       "middle_name": null,
#       "created_at": "1732-02-22T12:34:56Z",
#       "updated_at": "1799-12-14T12:34:56Z",
#       "confirmed_at": "1750-02-22T12:34:56Z",
#       "description": "First president of the United States",
#       "time_zone": "US/Eastern",
#       "manager_uuid": "9282fac0-2afb-0132-efb6-123139105d31",
#       "title": "President of the United States",
#       "employee_id": "1",
#       "personal_email": "woodenteeth@example.com",
#       "phone": "000-000-0001",
#       "home_phone": null,
#       "mobile_phone": null,
#       "emergency_contact_name": "Martha Washington",
#       "emergency_contact_relationship": "Wife",
#       "emergency_contact_mobile_phone": null
#       "emergency_contact_work_phone": null
#       "emergency_contact_home_phone": "000-000-0002",
#       "address_1": "123 Main St",
#       "address_2": null
#       "city": "Mount Vernon",
#       "state": "VA",
#       "zip": "22121",
#       "review_on": "2076-07-04",
#       "started_on": "1789-04-30",
#       "enabled": false,
#       "enabled_at": null
#     }
#
# #### Data Fields
#
#   * `uuid`: Universally Unique Identifier for this user
#   * `email`: Primary email
#   * `full_name`: Formatted name, may be `null`
#   * `first_name`: Personal name, may be `null`
#   * `last_name`: Surname, may be `null`
#   * `middle_name`: Middle name, may be `null`
#   * `created_at`: ISO8601 datetime of the creation of this user, in UTC
#   * `updated_at`: ISO8601 datetime of the time at which this user was updated, in UTC
#   * `confirmed_at`: ISO8601 datetime of the time at which this user was confirmed, in UTC
#   * `description`: The description of this user, may be `null`
#   * `time_zone`: The time zone of this user according to the [list of names from the Olson database](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
#   * `manager_uuid`: The uuid of the user's manager
#   * `title`: The job title of the user
#   * `employee_id`: The external employee id of the user
#   * `personal_email`: The personal email of the user
#   * `phone`: The user's primary phone
#   * `home_phone`: The user's home phone
#   * `mobile_phone`: The user's mobile phone
#   * `emergency_contact_name`: The user's emergency contact name
#   * `emergency_contact_relationship`: The user's emergency contact relationship
#   * `emergency_contact_mobile_phone`: The user's emergency contact's mobile phone
#   * `emergency_contact_work_phone`: The user's emergency contact's work phone
#   * `emergency_contact_home_phone`: The user's emergency contact's home phone
#   * `address_1`: The user's address line 1
#   * `address_2`: The user's address line 2
#   * `city`: The user's city name
#   * `state`: The user's standard state postal code (see [ISO-3166-2 for a list](http://en.wikipedia.org/wiki/ISO_3166-2:US))
#   * `zip`: The user's 5 or 9 digit zip code
#   * `review_on`: The ISO8601 date for the next review of this user
#   * `started_on`: The ISO8601 date when this user's employment started
#   * `enabled`: Whether this user is enabled, as a boolean value
#   * `enabled_at`: The ISO8601 datetime for when this user was enabled, in UTC
#
# ## GET /v1/users.json
#
# (currently in development)
#
# Get all users, optionally filtering by enabled or external employee ID.
#
# ### Example requests
#
#     GET /v1/users.json
#     GET /v1/users.json?enabled=false
#     GET /v1/users.json?enabled=true
#     GET /v1/users.json?employee_id=1234
#
# ### Example responses
#
# #### HTTP 200 OK
#
#     {
#       "users" : [
#         //Content from GET /v1/users/:uuid.json
#       ]
#     }
#
# #### HTTP 500 Server Error
#
# ## POST /v1/users.json
#
# (currently in development)
#
# Create a new user
#
# ### Example requests
#
#     POST /v1/users.json
#     Content-Type: application/json
#
#     {
#       "user": {
#         "email": "abe@whitehouse.gov",
#         "password": "yeeK0ixaey7zaxoh6pee!",
#         "first_name": "Abraham",
#         "last_name": "Lincoln"
#       }
#     }
#
# ### Request fields
#
# The following fields are allowed:
#
#   * `email`: **Required**
#   * `password`: **Required.**  Plain-text password.
#     * Note: requests are only allowed over HTTPS.
#     * This value is not returned by a `GET` request.
#     * Password must contain at least 3 of the 4 character groups: Uppercase, Lowercase, Number, Non-Alphanumeric (punctuation, whitespace, etc.)'
#   * `first_name`: **Required**
#   * `last_name`: **Required**
#   * `middle_name`
#   * `description`
#   * `time_zone`
#   * `manager_id`
#   * `title`
#   * `employee_id`
#   * `personal_email`
#   * `phone`
#   * `home_phone`
#   * `mobile_phone`
#   * `emergency_contact_name`
#   * `emergency_contact_relationship`
#   * `emergency_contact_mobile_phone`
#   * `emergency_contact_work_phone`
#   * `emergency_contact_home_phone`
#   * `address_1`
#   * `address_2`
#   * `city`
#   * `state`
#   * `zip`
#   * `review_on`
#   * `started_on`
#   * `enabled`, defaults to `true`
#
# For field descriptions, please see `GET /v1/users/:uuid.json`.
#
# ### Example responses
#
# #### HTTP 200 OK
#
# Refer to `GET /v1/users/:id.json` response.
#
# #### HTTP 422 Unprocessable Entity
#
#     {
#       "errors": {
#         "email": [
#           "is invalid",
#         ]
#       }
#     }
#
# #### HTTP 500 Server Error
#
# ## PATCH /v1/users.json
#
# (currently in development)
#
# Updates a user
#
# ### Example requests
#
# Refer to `POST /v1/users.json` request.  NOTE: you can omit keys as necessary
#
# ### Example responses
#
# Refer to `GET /v1/users/:id.json` response
get '/users' do
  # TODO
end

# ## GET /v1/template_to_dos.json
#
# Get all the TemplateToDos for your organization.  NOTE: not filtered by enabled/disabled state.
#
# ### Example requests
#
#     GET /v1/template_to_dos.json #     GET /v1/template_to_dos.json?tags[]=annual&tags[]=security
#
# ### Request fields
#
#   * `tags`: Only return TemplateToDos that are tagged with all of the specified tags.
#
# ### Example response
#
# #### HTTP 200 OK
#
#     {
#       "template_to_dos": [
#         {
#           "uuid": "12345678-1234-5678-1234-567812345678",
#           "name": "Review server logs",
#           "tags": ["security", "annual", "training"]
#         }
#       ]
#     }
#
# #### HTTP 500 Server Error
#
# ### Response fields
#
#   * `template_to_dos`: an Array of TemplateToDos, or an empty array `[]` if none match the given criteria
#     * `uuid`: UUID for each TemplateToDo.
#     * `name`: The human-readable name for each ToDo.
#     * `tags`: The tags for each TemplateToDo, as an array of strings. If there are no tags, it will be an empty array.
#
get '/template_to_dos' do
  template_to_dos = ControlAPI.get("/v1/template_to_dos.json", :query => params)
  erb :template_to_dos, :locals => template_to_dos
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
#         "field_values": {"field1": "value1", "field2": "value2"},
#         "metadata": {"customer_id": "7676767", "loan_id": "1234-7890"}
#       }
#     }
#
# ### Request fields
#
#   * `distributed_to_do`: **Required**.  Holds parameters for the DistributedToDo.
#     * `template_to_do_uuid`: **Required**.  The UUID for the TemplateToDo that will be distributed.  This can be found via `GET /v1/template_to_dos`, or in Continuity Control under "Settings".
#     * `due_on`: **Required**.  ISO8601 date of when the DistributedToDo is due, in UTC.
#     * `assignee_emails`: **Required**.  An Array of email addresses of Users that will receive the DistributedToDos.
#     * `field_values`: Dictionary (Object) of values to pre-fill in the DistributedToDo.  Field names are available in Continuity Control under "Settings".
#     * `metadata`: Dictionary (Object) of additional key-value pairs. Values must be strings. Metadata can be used to hold any extra related data, and can be used in querying.  The key and value combined are limited to 247 characters.
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
#         "template_to_do_uuid": [
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
#   * `uuid`: A UUID for the DistributedToDo which will be created asynchronously. Please include it in any bug reports to Continuity.
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
#       "name": "Review server logs",
#       "created_at": "2013-11-02T12:34:46.000Z",
#       "completed_at": null,
#       "due_on": "2013-11-08",
#       "tags": ["security", "annual", "training"],
#       "metadata": {
#         "customer_id": "7676767",
#         "loan_id": "1234-7890"
#       },
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
#   * `name`: The human-readable name for this ToDo.
#   * `created_at`: ISO8601 datetime of the creation of this DistributedToDo, in UTC.
#   * `completed_at`: ISO8601 datetime of when the DistributedToDo was completed, in UTC.  This is when all the assignments have been finished.  May be `null`.
#   * `due_on`: ISO8601 date of when the DistributedToDo is due, in UTC.
#   * `tags`: The tags for this DistributedToDo, as an array of strings. If there are no tags, it will be an empty array.
#   * `metadata`: The metadata for this DistributedToDo, as an object. If there are no metadata, it will be an empty object. Values will always be returned as strings.
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
#     GET /v1/distributed_to_dos.json?created_after=2013-11-02
#     GET /v1/distributed_to_dos.json?created_after=2013-11-02&created_before=2013-11-07
#     GET /v1/distributed_to_dos.json?created_before=2013-11-07
#     GET /v1/distributed_to_dos.json?late=true
#     GET /v1/distributed_to_dos.json?complete=true
#     GET /v1/distributed_to_dos.json?created_after=2013-11-02&created_before=2013-11-07&late=true&complete=false
#     GET /v1/distributed_to_dos.json?tags[]=annual&tags[]=security
#     GET /v1/distributed_to_dos.json?metadata[customer_id]=7676767
#     GET /v1/distributed_to_dos.json?metadata[customer_id]=7676767&metadata[loan_id]=1234-7890
#
# ### Request fields
#
#   * `created_after`: ISO8601 date of exclusive lower bound of `created_at` time.
#   * `created_before`: ISO8601 date of exclusive upper bound of `created_at` time.
#   * `late`: When `true`, respond with only "late" DistributedToDos.  When `false`, respond with only "on time" DistributedToDos.  When not present, do not filter on lateness.
#   * `complete`: When `true`, respond with only "complete" DistributedToDos.  When `false`, respond with only "incomplete" DistributedToDos.  When not present, do not filter on completeness.
#   * `tags`: Only return DistributedToDos that are tagged with all of the specified tags.
#   * `metadata`: Only return DistributedToDos that have all the specified metadata.
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
  one_week_ago_params = { :created_after => Date.today - 7 }
  filter_params = params.empty? ? one_week_ago_params : params

  distributed_to_dos = ControlAPI.get('/v1/distributed_to_dos.json', :query => filter_params)
  erb :distributed_to_dos, :locals => distributed_to_dos
end

# ## Webhooks
#
# Webhooks provide information about events in near real-time.  You provide a URL, and we'll `POST` to it as events take place.  When a `HTTP 5XX` response occurs, the Webhook is retried with an incremental backoff.
#
# ### Format
#
# Our webhooks have the following format:
#
#     {
#
#       "event": "EventName",
#       "fired_at": "2014-06-24T15:32:05Z",
#       "data": {
#         // Depends on event, see below
#       }
#     }
#
# #### Fields
#
#   * `event`: A named event, as documented below
#   * `fired_at`: When the webhook was fired
#   * `data`: an Object of data for the given event
#
# ### Implementation Requirements
#
# The receiver of a webhook **MUST** check `event` on each `POST`.  An unknown `event` **MUST** be ignored.
#
# Examples of why this behavior is required:
#
# * If the `event` is not checked, and the receiver only looks at the `data.name` attribute, it could be a ToDo's name instead of a user's name.
# * If the `event` is not checked, a user could have been updated instead of created.  The receiver could then take action on an "updated" event that was only intended for a "created" event (e.g., sending a welcome email).
#
# ### Example
#
# For a contrived example, if there were a `VoteCast` event, the webhook would provide data like the following in two separate `POST`s:
#
# First `POST`:
#
#     {
#       "event": "VoteCast",
#       "fired_at": "2000-11-07T15:32:05Z",
#       "data": {
#         "full_name": "Al Gore",
#         "party": "Democrat"
#       }
#     }
#
# Second `POST`:
#
#     {
#       "event": "VoteCast",
#       "fired_at": "2000-11-07T15:42:05Z",
#       "data": {
#         "full_name": "George W Bush",
#         "party": "Republican"
#       }
#     }
#
# ## Events
#
# ### UserCreated
#
# The `UserCreated` event fires when a new user is created on Control.
#
# #### Data Example
#
#     {
#       "full_name": "George Washington",
#       "first_name": "George",
#       "last_name": "Washington",
#       "email": "gwashington@example.com"
#     }
#
# #### Data Fields
#
#   * `full_name`: Formatted name, may be `null`
#   * `first_name`: Personal name, may be `null`
#   * `last_name`: Surname, may be `null`
#   * `email`: Primary email
#
# ### DistributedToDoCompleted
#
# The `DistributedToDoCompleted` events fires when all the assignments of a ToDo are completed.  That is, when the ToDo as a whole is completed, rather than an individual user's assignment.
#
# The data is the same for `GET /v1/distributed_to_dos/:uuid.json`.  Please refer to its documentation.
#
post '/webhook' do
  event = parsed_body['event']
  data = parsed_body['data']

  case event
  when 'DistributedToDoCompleted'
    "Good job, team!  We completed the #{data['name']} ToDo!"
  when 'UserCreated'
    "Nice to meet you, #{data['full_name']}!"
  end
end
