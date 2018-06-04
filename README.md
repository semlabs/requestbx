# Requestbx

## Introduction
Requestbx is a very simple webserver which captures all incomming `POST` requests on every route and returns it on the same route on a `GET` request.

A `DELETE` on a specific route removes all requests on that route. A `DELETE` on `/` removes all requests from all routes.

It doesn't store anything in a database, so the data is lost as soon the server restarts. The state is stored in an ets table.

Requestbx is intended for testing purposes only, for example if you want to test webhooks.

The server runs on port `4002`, also included is a docker container.

## Parameters

Parameter | Details | Default
--- | --- | ---
expected_items | Waits until expected item count is reached or until timeout | 1
max_waiting | The max timout to wait for expected_items in 10 ms steps | 100 (= 1 second)

## Start
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).
