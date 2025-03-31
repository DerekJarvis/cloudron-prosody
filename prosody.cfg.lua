-- see example config at https://hg.prosody.im/0.9/file/0.9.10/prosody.cfg.lua.dist
-- easily extendable by putting into different config files within conf.d folder

local stringy = require "stringy" 

local prosody_admins = os.getenv("PROSODY_ADMINS") or "";
admins = stringy.split(prosody_admins, ", ");

pidfile = "/app/data/prosody.pid"

-- Set data directory to path provided by Cloudron storage addon
-- not needed, compiling with this set
-- data_path = "/app/data/data"

allow_registration = os.getenv("ALLOW_REGISTRATION");

-- Make sure we're listening on external interfaces
http_interfaces = { "0.0.0.0", "::1" }
https_interfaces = { "0.0.0.0", "::1" }

c2s_require_encryption = os.getenv("C2S_REQUIRE_ENCRYPTION");
s2s_require_encryption = os.getenv("S2S_REQUIRE_ENCRYPTION");
s2s_secure_auth = os.getenv("S2S_SECURE_AUTH");

authentication = os.getenv("AUTHENTICATION") or "internal_hashed";

ldap_base = os.getenv("LDAP_BASE");
ldap_server = os.getenv("LDAP_SERVER") or "localhost";
ldap_rootdn = os.getenv("LDAP_ROOTDN") or "";
ldap_password = os.getenv("LDAP_PASSWORD") or "";
ldap_filter = os.getenv("LDAP_FILTER") or "(uid=$user)";
ldap_scope = os.getenv("LDAP_SCOPE") or "subtree";
ldap_tls = os.getenv("LDAP_TLS") or "false";
ldap_mode = os.getenv("LDAP_MODE") or "bind";
ldap_admin_filter = os.getenv("LDAP_ADMIN_FILTER") or "";

turn_external_host = os.getenv("TURN_SERVER")
turn_external_secret = os.getenv("TURN_SECRET")

log = {
    {levels = {min = os.getenv("LOG_LEVEL") or "info"}, to = "console"};
};

Include "conf.d/*.cfg.lua";
