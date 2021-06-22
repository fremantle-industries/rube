# Rube

[![Build Status](https://github.com/fremantle-industries/rube/workflows/test/badge.svg?branch=main)](https://github.com/fremantle-industries/rube/actions?query=workflow%3Atest)
[![hex.pm version](https://img.shields.io/hexpm/v/rube.svg?style=flat)](https://hex.pm/packages/rube)

A DeFi development toolkit for Elixir

[![rube-poc-overview](./docs/rube-poc-overview-thumbnail.png)](https://youtu.be/f2phGFZrh80)

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

You can run the app natively on the host `http://rube.localhost:4000`

```bash
$ mix setup
$ mix phx.server
```


Or within `docker-compose` `http://rube.localhost`

```
$ docker-compose up
```

When running the application with `docker-compose` you will need to enter the basic auth development credentials:

```
username: admin
passowrd: password
```

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
