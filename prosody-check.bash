#!/bin/bash
set -e

# Cloudron defaults & Env Mappings
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

if [ -z "$DOMAIN" ]; then
  echo "[ERROR] DOMAIN must be set!"
  exit 1
fi

/app/data/bin/prosodyctl --config /app/data/prosody.cfg.lua check