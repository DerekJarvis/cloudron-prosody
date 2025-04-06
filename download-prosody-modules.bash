#!/bin/bash
set -e

dir="/usr/src/prosody-modules"

mkdir -p "${dir}"
wget https://hg.prosody.im/prosody-modules/archive/tip.tar.gz
tar -xzf tip.tar.gz -C "${dir}" --strip-components=1
rm tip.tar.gz
