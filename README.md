# Continuity Control API Reference

An example of integrating with the Continuity Control API using Sinatra + HTTParty.

This guide assumes you have a Continuity Control API key.  To obtain an API key, please log into Control and then go to Settings -> API Access -> Generate New Key Pair.

## Quick links

* [API documentation](http://continuitycontrol.github.io/control_api_reference/)
* [Change Log](ChangeLog)
* [Control](https://control.continuity.net)
* [Sample application](http://control-api-reference.herokuapp.com/) (this code)

## Running this code

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

The API documentation is inline with examples in [app.rb](app.rb).  There is also a [documentation website generated from the contents of that file](http://continuitycontrol.github.io/control_api_reference/).
