#!/bin/bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

endpoint="${1:-}"
useragent="${2:-OpenConnect}"

usage() {
    echo "usage: $0 https://<vpn-gateway> [<user-agent>]"
    exit 1
}

cleanup() {
    echo >vpn.env
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

if docker compose ps -q | grep -q . ; then
    echo "VPN containers are already running, stopping first"
    ./down.sh
fi

openconnect \
    --useragent="${useragent}" \
    --external-browser "${browser}" \
    --authenticate \
    "${endpoint}" \
  | sponge vpn.env

docker compose up -d
