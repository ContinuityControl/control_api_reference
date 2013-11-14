# Continuity Control API Reference

An example of integrating with the Continuity Control API using Sinatra + HTTParty.

This guide assumes you have a Continuity Control API key.  Please log into [Control](https://control.continuity.net) to request an API key.

## Quick links

* [API documentation](http://continuitycontrol.github.io/control_api_reference/)
* [Control](https://control.continuity.net)
* [Sample application](http://control-api-reference.herokuapp.com/) (this code)

## Running this code

You'll need Ruby 2.0.0 installed.  Please see [the Ruby installation guide for more information](https://www.ruby-lang.org/en/downloads/).

You need to configure an ignored file called `.env` that points to the API server you're using.

For testing, `.env` would be:

    CONTROL_API_BASE_URI=https://sandbox.continuity.net/
    CONTROL_API_KEY='YOUR-TOKEN'

For production, `.env` would be:

    CONTROL_API_BASE_URI=https://api.continuity.net/
    CONTROL_API_KEY='YOUR-TOKEN'

To get started:

    bundle
    rackup

The default port is `4567`, so you can test your connection like so:

    curl http://localhost:4567/status
    # => API status: up

You can also visit [http://localhost:4567/status](http://localhost:4567/status) in your web browser.

If you do not see `API status: up`, there are several possible causes:

  * The Ruby application did not start correctly
  * The configuration is not correct (e.g. `.env`)
  * Your code is stale, `git pull` and then `bundle`
  * The configured API is unreachable

(This list is not exhaustive.)

## API documentation

The API documentation is inline with examples in [app.rb](app.rb).  There is also a [documentation website generated from the contents of that file](http://continuitycontrol.github.io/control_api_reference/).
