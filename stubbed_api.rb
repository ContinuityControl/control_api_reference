require 'sinatra'
require 'sinatra/reloader' if development?

# This file is for initial testing purposes only.

set :port, 5001
$client_error = true

get '/v1/status' do
  content_type 'application/json'
  [200, '{"description":"stubbed via Sinatra"}']
end

post '/v1/distributed_to_dos' do
  content_type 'application/json'

  if $client_error
    [422, '{"errors":{"assignee_emails":["has invalid email address alice@example.com","has invalid email address bob@example.com"]}}']
  else
    [202, '{"id":"f81d4fae-7dec-11d0-a765-00a0c91e6bf6", "path":"/v1/distributed_to_dos/f81d4fae-7dec-11d0-a765-00a0c91e6bf6"}']
  end
end

get '/v1/distributed_to_dos/:id' do
  content_type 'application/json'

  if $client_error
    [404, 'Not Found']
  else
    [200, '{ "id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6", "created_at": "2013-11-02T12:34:46Z", "completed_at": "2013-11-07T12:34:56Z", "due_on": "2013-11-08", "assignments": [ { "email": "bobama@example.com", "finished_on": "2013-11-07" }, { "email": "bclinton@example.com", "finished_on": null } ] }']
  end
end

get '/v1/distributed_to_dos' do
  content_type 'application/json'
  [200, '{ "distributed_to_dos": [ { "id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6", "created_at": "2013-11-02T12:34:46Z", "completed_at": "2013-11-07T12:34:56Z", "due_on": "2013-11-08", "assignments": [ { "email": "bobama@example.com", "finished_on": "2013-11-07" }, { "email": "bclinton@example.com", "finished_on": null } ] } ] }']
end
