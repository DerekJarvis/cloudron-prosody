#!/bin/bash

set -e

# Copy all files from startup to permanent data
cp -r /usr/local/startup/. /app/data

mkdir -p /app/data/custom-modules

# Ejabberd module config
/app/data/scripts/download-prosody-modules.bash && \
/app/data/scripts/docker-prosody-module-install.bash \
        bookmarks `# XEP-0411: Bookmarks Conversion` \
        carbons `# message carbons (XEP-0280)` \
        cloud_notify `# XEP-0357: Push Notifications` \
        csi `# client state indication (XEP-0352)` \
        e2e_policy `# require end-2-end encryption` \
        filter_chatstates `# disable "X is typing" type messages` \
        smacks `# stream management (XEP-0198)` \
        throttle_presence `# presence throttling in CSI` \
        vcard_muc `# XEP-0153: vCard-Based Avatar (MUC)` \
        host_status_check `#Cloudron: Health checker` \
        http_host_status_check `#Cloudron: HTTP Endpoint for Health checker` \
 && rm -rf "/app/data/prosody-modules"

mkdir -p /app/data/data
mkdir -p /app/data/certs

cp /etc/certs/tls_cert.pem /app/data/certs/fullchain.pem
cp /etc/certs/tls_key.pem /app/data/certs/privkey.pem

# Change ownership
chown -R prosody:prosody /app/data

# exec ls -lah /app/data
# exec /usr/local/bin/gosu prosody:prosody ls -lahR /usr/local/var/lib/prosody
exec /usr/local/bin/gosu prosody:prosody /app/data/scripts/prosody-start.bash
# --config /app/data/prosody.cfg.lua