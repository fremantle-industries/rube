FROM bitwalker/alpine-elixir-phoenix:1.11.4 AS builder
WORKDIR /tmp/app
RUN chown -R nobody: /tmp/app
RUN apk add --update alpine-sdk
RUN apk add rust cargo
COPY ./.iex.exs .iex.exs
COPY ./mix.exs ./
COPY ./mix.lock ./
COPY ./assets/css ./assets/css
COPY ./assets/js ./assets/js
COPY ./assets/static ./assets/static
COPY ./assets/package.json ./assets/package.json
COPY ./assets/package-lock.json ./assets/package-lock.json
COPY ./assets/webpack.config.js ./assets/webpack.config.js
COPY ./assets/postcss.config.js ./assets/postcss.config.js
COPY ./assets/tailwind.config.js ./assets/tailwind.config.js
COPY ./assets/tsconfig.json ./assets/tsconfig.json
COPY ./config ./config
COPY ./lib ./lib
COPY ./priv/repo ./priv/repo
COPY ./rel ./rel
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix clean --deps
RUN mix setup.deps

FROM bitwalker/alpine-elixir-phoenix:1.11.4 AS release
ARG release_name
WORKDIR /tmp/app
RUN chown -R nobody: /tmp/app
COPY --from=builder /tmp/app .
RUN apk add --update alpine-sdk
RUN mix local.hex --force
RUN mix local.rebar --force
RUN npm run deploy --prefix=assets
RUN MIX_ENV=prod mix phx.digest
RUN MIX_ENV=prod mix release $release_name
# Print script with evaluated env vars when executed. This is useful for
# debugging problems starting the application correctly
# RUN cat _build/prod/rel/$release_name/bin/$release_name \
#       | sed -e 's/set[ ]-e/set -ex/' \
#       > _build/prod/rel/$release_name/bin/$release_name

FROM elixir:1.11.4-alpine AS app
ARG release_name
WORKDIR /app
RUN chown -R nobody: /app
# Bash is required to source with arguments
# https://github.com/edib-tool/docker-edib-tool/issues/15#issuecomment-325252150
RUN apk upgrade --no-cache
RUN apk add --no-cache bash
ENV SHELL=/bin/bash
ENV RELEASE_NAME=$release_name
ENV MIX_ENV=prod
COPY --from=release /tmp/app/_build/prod/rel/$release_name .
COPY --from=release /tmp/app/.iex.exs .
CMD /bin/sh -c 'bin/$RELEASE_NAME start'
