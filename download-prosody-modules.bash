#!/bin/bash
set -e

dir="/app/data/prosody-modules"

mkdir -p "${dir}"

tar -xzf /usr/local/startup/tip.tar.gz -C "${dir}" --strip-components=1