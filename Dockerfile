FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

RUN mkdir assets

COPY assets/package.json assets
COPY assets/package-lock.json assets

CMD mix deps.get && cd assets && npm install && cd .. && mix phx.server
