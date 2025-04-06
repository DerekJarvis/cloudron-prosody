#!/bin/bash
#set -e

# Copy all certs! Do this until we can get the TLD from an addon
# The prosody-start script will rearrange as necessary because it has the variables
# cp /home/yellowtent/platformdata/nginx/cert/* /app/data/certs/
# TODO: Replace this with a better approach
cp /media/Extra\ Storage/app_xmpp/* /app/data/certs/

# Re-arrange Certs
mkdir -p /app/data/certs/$DOMAIN_HTTP_UPLOAD
cp /app/data/certs/$DOMAIN_HTTP_UPLOAD.cert /app/data/certs/$DOMAIN_HTTP_UPLOAD/fullchain.pem
cp /app/data/certs/$DOMAIN_HTTP_UPLOAD.key /app/data/certs/$DOMAIN_HTTP_UPLOAD/privkey.pem

mkdir -p /app/data/certs/$DOMAIN_MUC
cp /app/data/certs/$DOMAIN_MUC.cert /app/data/certs/$DOMAIN_MUC/fullchain.pem
cp /app/data/certs/$DOMAIN_MUC.key /app/data/certs/$DOMAIN_MUC/privkey.pem

mkdir -p /app/data/certs/$DOMAIN_PROXY
cp /app/data/certs/$DOMAIN_PROXY.cert /app/data/certs/$DOMAIN_PROXY/fullchain.pem
cp /app/data/certs/$DOMAIN_PROXY.key /app/data/certs/$DOMAIN_PROXY/privkey.pem

mkdir -p /app/data/certs/$DOMAIN_PUBSUB
cp /app/data/certs/$DOMAIN_PUBSUB.cert /app/data/certs/$DOMAIN_PUBSUB/fullchain.pem
cp /app/data/certs/$DOMAIN_PUBSUB.key /app/data/certs/$DOMAIN_PUBSUB/privkey.pem

mkdir -p /app/data/certs/$DOMAIN_APP
cp /app/data/certs/$DOMAIN_APP.cert /app/data/certs/$DOMAIN_APP/fullchain.pem
cp /app/data/certs/$DOMAIN_APP.key /app/data/certs/$DOMAIN_APP/privkey.pem

mkdir -p /app/data/certs/$DOMAIN
cp /app/data/certs/$DOMAIN.cert /app/data/certs/$DOMAIN/fullchain.pem
cp /app/data/certs/$DOMAIN.key /app/data/certs/$DOMAIN/privkey.pem

# TODO: Get the TLD cert from cloudron in a cleaner way
# Now clean up all certs we copied in blindly, since that was a bad idea
rm /app/data/certs/*.cert
rm /app/data/certs/*.key