#!/bin/bash
set -e

# set environment variables and do cert setup 
source cloudron-env.bash
source cloudron-cert-setup.bash

# Change ownership
chown -R prosody:prosody /app/data

# Cloudron users a separate script to run prosodyctl commands, and local users aren't used
#if [[ "$1" != "prosody" ]]; then
#    exec prosodyctl $*
#    exit 0;
#fi

#if [ "$LOCAL" -a "$PASSWORD" -a "$DOMAIN" ] ; then
#    prosodyctl register $LOCAL $DOMAIN $PASSWORD
#fi

#if [ -z "$DOMAIN" ]; then
#  echo "[ERROR] DOMAIN must be set!"
#  exit 1
#fi

exec /usr/local/bin/gosu prosody:prosody prosody -F
