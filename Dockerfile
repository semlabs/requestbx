FROM elixir:1.5.2

ENV DEBIAN_FRONTEND=noninteractive

ARG ENV=prod

ENV MIX_ENV=$ENV REPLACE_OS_VARS=true

COPY . /app/
WORKDIR /app

RUN rm -rf _build \
    && rm -rf deps

# Install hex & rebar
RUN mix do \
      local.hex --force, \
      deps.clean --all, \
      deps.get

#HTTP
EXPOSE 4002

# Finally run the server
CMD elixir -S mix phx.server
