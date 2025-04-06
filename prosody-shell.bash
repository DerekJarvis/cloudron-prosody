#!/bin/bash
set -e

source cloudron-env.bash

if [ -z "$DOMAIN" ]; then
  echo "[ERROR] DOMAIN must be set!"
  exit 1
fi

prosodyctl shell