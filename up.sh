#!/bin/bash

set -euo pipefail

endpoint="$1"

usage() {
    echo "usage: $0 https://<vpn-gateway>"
    exit 1
}

cleanup() {
    rm -f vpn.env
}
trap cleanup EXIT

if which open >/dev/null; then
    browser=$(which open)
else
    browser=$(which xdg-open)
fi

if [ -z "${endpoint}" ]; then
    usage
fi

openconnect \
    --useragent="AnyConnect-compatible OpenConnect VPN Agent" \
    --external-browser "${browser}" \
    --authenticate \
    "${endpoint}" \
  | sponge vpn.env

docker compose up -d
