#!/bin/sh

printenv

echo starting openconnect

exec openconnect --cookie "${COOKIE}" "${CONNECT_URL}" --servercert "${FINGERPRINT}" --resolve "${RESOLVE}"
