# Rube

[![Build Status](https://github.com/fremantle-industries/rube/workflows/test/badge.svg?branch=main)](https://github.com/fremantle-industries/rube/actions?query=workflow%3Atest)
[![hex.pm version](https://img.shields.io/hexpm/v/rube.svg?style=flat)](https://hex.pm/packages/rube)

A DeFi development toolkit

## Install

Add `rube` to your list of dependencies in `mix.exs`

```elixir
def deps do
  [
    {:rube, "~> 0.0.1"}
  ]
end
```

## Development

You can run the app natively on the host

```bash
$ mix setup
$ mix phx.server
```

Or within `docker-compose`

```
$ docker-compose up
```

Wait a few seconds for the app to boot and you should be able to view the app at `http://rube.localhost:4000`

## Test

```bash
$ mix test
```

## Help Wanted :)

If you think this `rube` thing might be worthwhile and you don't see a feature
we would love your contributions to add them! Feel free to drop us an email or open
a Github issue.

## Authors

* [Alex Kwiatkowski](https://github.com/rupurt) - alex+git@fremantle.io

## License

`rube` is released under the [MIT license](./LICENSE.md)
