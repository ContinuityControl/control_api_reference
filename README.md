# Continuity Control API Reference

An example of integrating with the Continuity Control API using Sinatra + HTTParty.

## Quick links

* [API documentation][api_docs]
* [Change Log](ChangeLog)
* [Control](https://control.continuity.net)
* [Sample application](http://control-api-reference.herokuapp.com/) (reference implementation)

## Quick Start

In order to use the Continuity Control API you will need to follow the steps below:

  1. Set up an API key on Control. To obtain an API key, please visit [API Access in Control](https://control.continuity.net/settings/api_users).
  2. Make a request for the status of the API using your tool of choice. For example, `curl -u $CONTROL_API_KEY:$CONTROL_API_SECRET https://api.continuity.net/v1/status.json`
  3. Verify that you see a response that states the service is up
  4. Review this README and the [API documentation][api_docs] for more details on how to use all features of the API
  5. Grab a cup of coffee, you're done! :-)

## Running this reference implementation

You'll need Ruby 2.0.0 installed.  Please see [the Ruby installation guide for more information](https://www.ruby-lang.org/en/downloads/).

You need to configure a git-ignored file called `.env` that points to the API server you're using.

For example, `.env` would be:

    CONTROL_API_BASE_URI=https://api.continuity.net/
    CONTROL_API_KEY='YOUR-API-KEY'
    CONTROL_API_SECRET='YOUR-API-SECRET'

If you would like separate credentials for testing in a "sandbox" organization, please contact us.

To get started:

    gem install bundler
    bundle
    bundle exec rackup

The default port is `9292`, so you can test your connection like so:

    curl http://localhost:9292/status
    # => API status: up

You can also visit [http://localhost:9292/status](http://localhost:9292/status) in your web browser.

If you do not see `API status: up`, there are several possible causes:

  * The Ruby application did not start correctly
  * The configuration is not correct (e.g. `.env`)
  * Your code is stale, `git pull` and then `bundle`
  * The configured API is unreachable

(This list is not exhaustive.)

## API documentation

The API documentation is inline with examples in [app.rb](app.rb).  There is also a [documentation website generated from the contents of that file][api_docs].

  [api_docs]: http://continuitycontrol.github.io/control_api_reference/
