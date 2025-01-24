# openconnect + socks proxy

## What

Runs `openconnect` and a SOCKS proxy in a containerized environment.

## Why

Many VPN services tend to push a default route that forces all egress traffic through the VPN exit node.

There is often a good reason for that, but in case you know what you're doing this repo provides a mechanism to "isolate"
the network environment that uses the VPN from your main computer and allow you to _selectively_ choose which applications
will use the VPN.

## Requirements

* Docker
* `openconnect` installed locally

(macos: `brew install openconnect`, debian: `apt-get install openconnect`, ...)

## How to use

```bash
./up.sh https://my-vpn-gateway/foo/bar
```

Now you can configure the applications that need to access resources in the VPN to use the SOCKS proxy at `localhost:1080`. E.g:

* `HTTPS_PROXY=socks5://localhost:1080` ( `curl`, `kubectl`, most `python` scripts, ... )
* Browser extensions such as [Proxy SwitchyOmega](https://chromewebstore.google.com/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif?hl=en)
* You may need to `pip install PySocks` for python scripts to pick up the `HTTPS_PROXY` env var

To shut the VPN down:

```bash
./down.sh
```

## How it works

1. The `up.sh` script first runs `openconnect` locally to authenticate to the VPN 
2. The ephemeral VPN parameters are saved in a local file `vpn.env`
3. The `up.sh` script runs `docker compose up`
4. The docker compose config contains two containers: one running `openconnect` and one running dante `sockd` proxy
5. The sockd proxy container waits until the openconnect container is healthy because the `tun0` interface must exist for `sockd` to startup.


## Security note

The `vpn.env` file contains ephemeral connection parameters that are valid for a short time and are valid only for one connection attempt.

I decided it was "good enough" for me to keep them in a file because they cannot be reused for another connection.

But technically there is a short time while these credentials could be stolen by another process.

TODO: figure out how to pass these parameters securely to docker compose.