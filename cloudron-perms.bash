#!/bin/bash
set -e

# First assert Cloudron ownership
chown -R cloudron:cloudron /app/data

# Cloudron Cert copying
# Cloudron will restart the container when the cert changes
# Which will cause these to be updated
mkdir -p /app/data/certs/$DOMAIN_HTTP_UPLOAD
cp /etc/certs/tls_cert.pem /app/data/certs/$DOMAIN_HTTP_UPLOAD/fullchain.pem
cp /etc/certs/tls_key.pem /app/data/certs/$DOMAIN_HTTP_UPLOAD/privkey.pem

mkdir -p /app/data/certs/$DOMAIN_MUC
cp /etc/certs/tls_cert.pem /app/data/certs/$DOMAIN_MUC/fullchain.pem
cp /etc/certs/tls_key.pem /app/data/certs/$DOMAIN_MUC/privkey.pem

mkdir -p /app/data/certs/$DOMAIN_PROXY
cp /etc/certs/tls_cert.pem /app/data/certs/$DOMAIN_PROXY/fullchain.pem
cp /etc/certs/tls_key.pem /app/data/certs/$DOMAIN_PROXY/privkey.pem

mkdir -p /app/data/certs/$DOMAIN
cp /etc/certs/tls_cert.pem /app/data/certs/$DOMAIN/fullchain.pem
cp /etc/certs/tls_key.pem /app/data/certs/$DOMAIN/privkey.pem


# Update ownership of data directory
# prosody is hard-coded to use 999
chown -R 999:999 /app/data