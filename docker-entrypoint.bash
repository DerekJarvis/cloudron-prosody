#!/bin/bash
set -e

# Cloudron dfeaults & Env Mappings
export ALLOW_REGISTRATION=FALSE
# uncomment for debugging
#export DOMAIN=xmpp.alkalight.llc
export DOMAIN=${CLOUDRON_APP_DOMAIN}
export AUTHENTICATION="ldap"
export LDAP_BASE=${CLOUDRON_LDAP_USERS_BASE_DN}
export LDAP_SERVER=${CLOUDRON_LDAP_SERVER}
export LDAP_FILTER="(&(objectclass=user)(|(username=%uid)(mail=%uid)))" # Recommended filter
export LDAP_ADMIN_FILTER="(&(objectclass=user)(memberof=CN=admin,ou=groups,dc=cloudron)(|(username=%uid)(mail=%uid)))" # Guess at how to identify admins

export DOMAIN_HTTP_UPLOAD=${DOMAIN_HTTP_UPLOAD:-"upload.$DOMAIN"}
export DOMAIN_MUC=${DOMAIN_MUC:-"conference.$DOMAIN"}
export DOMAIN_PROXY=${DOMAIN_PROXY:-"proxy.$DOMAIN"}
export DOMAIN_PUBSUB=${DOMAIN_PUBSUB:-"pubsub.$DOMAIN"}
export DB_DRIVER=${DB_DRIVER:-"SQLite3"}
export DB_DATABASE=${DB_DATABASE:-"prosody.sqlite"}
export E2E_POLICY_CHAT=${E2E_POLICY_CHAT:-"required"}
export E2E_POLICY_MUC=${E2E_POLICY_MUC:-"required"}
export E2E_POLICY_WHITELIST=${E2E_POLICY_WHITELIST:-""}
export LOG_LEVEL=${LOG_LEVEL:-"info"}
export C2S_REQUIRE_ENCRYPTION=${C2S_REQUIRE_ENCRYPTION:-true}
export S2S_REQUIRE_ENCRYPTION=${S2S_REQUIRE_ENCRYPTION:-true}
export S2S_SECURE_AUTH=${S2S_SECURE_AUTH:-true}
export SERVER_CONTACT_INFO_ABUSE=${SERVER_CONTACT_INFO_ABUSE:-"xmpp:abuse@$DOMAIN"}
export SERVER_CONTACT_INFO_ADMIN=${SERVER_CONTACT_INFO_ADMIN:-"xmpp:admin@$DOMAIN"}
export SERVER_CONTACT_INFO_FEEDBACK=${SERVER_CONTACT_INFO_FEEDBACK:-"xmpp:feedback@$DOMAIN"}
export SERVER_CONTACT_INFO_SALES=${SERVER_CONTACT_INFO_SALES:-"xmpp:sales@$DOMAIN"}
export SERVER_CONTACT_INFO_SECURITY=${SERVER_CONTACT_INFO_SECURITY:-"xmpp:security@$DOMAIN"}
export SERVER_CONTACT_INFO_SUPPORT=${SERVER_CONTACT_INFO_SUPPORT:-"xmpp:support@$DOMAIN"}
export PROSODY_ADMINS=${PROSODY_ADMINS:-""}

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
        auth_ldap `#Cloudron: LDAP Auth` \
        host_status_check `#Cloudron: Health checker` \
        http_host_status_check `#Cloudron: HTTP Endpoint for Health checker` \
 && rm -rf "/app/data/prosody-modules"

# Cloudron Cert copying
# Cloudron will restart the container when the cert changes
# Which w# cp /usr/local/bin/prosody* /app/data/ill cause these to be updated

# cp /usr/local/bin/prosody* /app/data/

mkdir -p /app/data/data

# Prosody run directory
# mkdir -p /app/data/run
# Prosody lib directory
# mkdir -p /app/data/lib

# These commands still error with:
#mkdir: cannot create directory '/app/data/certs': Permission denied
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

if [ -z "$DOMAIN" ]; then
  echo "[ERROR] DOMAIN must be set!"
  exit 1
fi

# Assert ownership
chown -R prosody:prosody /app/data

# exec ls -lah /app/data
# exec /usr/local/bin/gosu prosody:prosody ls -lahR /usr/local/var/lib/prosody
exec /usr/local/bin/gosu prosody:prosody /app/data/bin/prosody -F
# --config /app/data/prosody.cfg.lua