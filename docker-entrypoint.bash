#!/bin/bash

set -e

# Copy all files from startup to permanent data
cp -r /usr/local/startup/. /app/data

mkdir -p /app/data/custom-modules

# Ejabberd module config
/app/data/scripts/download-prosody-modules.bash && \
/app/data/scripts/docker-prosody-module-install.bash \
        cloud_notify `# XEP-0357: Push Notifications` \
        e2e_policy `# require end-2-end encryption` \
        filter_chatstates `# disable "X is typing" type messages` \
        throttle_presence `# presence throttling in CSI` \
        vcard_muc `# XEP-0153: vCard-Based Avatar (MUC)` \
        host_status_check `#Cloudron: Health checker` \
        http_host_status_check `#Cloudron: HTTP Endpoint for Health checker` \
        turn_external `#Cloudron: STUN/TURN Connectivity` \
        cloud_notify `#Cloudron: For XEP-0357: Push Notifications` \
 && rm -rf "/app/data/prosody-modules"

mkdir -p /app/data/data
mkdir -p /app/data/certs

# Copy all certs! Do this until we can get the TLD from an addon
# The prosody-start script will rearrange as necessary because it has the variables
# cp /home/yellowtent/platformdata/nginx/cert/* /app/data/certs/
cp /media/Extra\ Storage/app_xmpp/* /app/data/certs/

# Change ownership
chown -R prosody:prosody /app/data

# exec ls -lah /app/data
# exec /usr/local/bin/gosu prosody:prosody ls -lahR /usr/local/var/lib/prosody
exec /usr/local/bin/gosu prosody:prosody /app/data/scripts/prosody-start.bash
# --config /app/data/prosody.cfg.lua