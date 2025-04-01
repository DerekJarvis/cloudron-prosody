FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ARG LUAROCKS_VERSION=3.11.1
ARG PROSODY_VERSION=0.12.5
ARG LUAROCKS_VERSION=3.11.1
ARG PROSODY_VERSION=0.12.5

ARG LUAROCKS_SHA256="c3fb3d960dffb2b2fe9de7e3cb004dc4d0b34bb3d342578af84f84325c669102"
ARG PROSODY_DOWNLOAD_SHA256="778fb7707a0f10399595ba7ab9c66dd2a2288c0ae3a7fe4ab78f97d462bd399f"
ARG LUAROCKS_SHA256="c3fb3d960dffb2b2fe9de7e3cb004dc4d0b34bb3d342578af84f84325c669102"
ARG PROSODY_DOWNLOAD_SHA256="778fb7707a0f10399595ba7ab9c66dd2a2288c0ae3a7fe4ab78f97d462bd399f"

LABEL luarocks.version="${LUAROCKS_VERSION}"
LABEL org.opencontainers.image.authors="Sara Smiseth"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.description="This docker image provides you with a configured Prosody XMPP server."
LABEL org.opencontainers.image.documentation="https://github.com/SaraSmiseth/prosody/blob/dev/readme.md"
LABEL org.opencontainers.image.revision="${VCS_REF}"
LABEL org.opencontainers.image.source="https://github.com/SaraSmiseth/prosody/archive/dev.zip"
LABEL org.opencontainers.image.title="prosody"
LABEL org.opencontainers.image.url="https://github.com/SaraSmiseth/prosody"
LABEL org.opencontainers.image.vendor="Sara Smiseth"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL prosody.version="${PROSODY_VERSION}"

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      libevent-dev `# this is no build dependency, but needed for luaevent` \
      libicu70 \
      libidn2-0 \
      libpq-dev \
      libsqlite3-0 \
      lua5.2 \
      lua-bitop \
      lua-dbi-mysql \
      lua-dbi-postgresql \
      lua-expat \
      lua-filesystem \
      lua-ldap \
      lua-socket \
      lua-sec \
      lua-unbound \
      wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN buildDeps='gcc git libc6-dev libidn2-dev liblua5.2-dev libsqlite3-dev libssl-dev libicu-dev make unzip' \
 && set -x \
 && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
 && rm -rf /var/lib/apt/lists/* \
 \
 && wget -O prosody.tar.gz "https://prosody.im/downloads/source/prosody-${PROSODY_VERSION}.tar.gz" \
 && echo "${PROSODY_DOWNLOAD_SHA256} *prosody.tar.gz" | sha256sum -c - \
 && mkdir -p /usr/src/prosody \
 && tar -xzf prosody.tar.gz -C /usr/src/prosody --strip-components=1 \
 && rm prosody.tar.gz \
 && cd /usr/src/prosody && ./configure --prefix=/app/data --datadir=/app/data/data --no-example-certs \
 && make \
 && make install \
 && cd / && rm -r /usr/src/prosody \
 \
 && mkdir /usr/src/luarocks \
 && cd /usr/src/luarocks \
 && wget https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz \
 && echo "${LUAROCKS_SHA256} luarocks-${LUAROCKS_VERSION}.tar.gz" | sha256sum -c - \
 && tar zxpf luarocks-${LUAROCKS_VERSION}.tar.gz \
 && cd luarocks-${LUAROCKS_VERSION} \
 && ./configure \
 && make bootstrap \
 && cd / && rm -r /usr/src/luarocks \
 \
 && luarocks install luaevent \
 && luarocks install luadbi \
 `#&& luarocks install luadbi-mysql MYSQL_INCDIR=/usr/include/mariadb/` \
 && luarocks install luadbi-sqlite3 \
 && luarocks install stringy \
 \
 && apt-get purge -y --auto-remove $buildDeps

EXPOSE 5000 5222 5223 5269 5347 5280 5281

# Not needed - Cloudron makes its own user which we will map to Prosody later
#RUN groupadd -r prosody \
# && useradd -r -g prosody prosody \
# && chown prosody:prosody /usr/local/var/lib/prosody

# Not Needed - Cloudron creates the /app/data directory automatically
#RUN mkdir -p /var/run/prosody/ \
# && chown prosody:prosody /var/run/prosody/

# https://github.com/prosody/prosody-docker/issues/25
ENV __FLUSH_LOG=yes

# Not Needed - Cloudron automatically creates the /app/data directory
#VOLUME ["/usr/local/var/lib/prosody"]

COPY docker-entrypoint.bash /entrypoint.bash

RUN wget https://hg.prosody.im/prosody-modules/archive/tip.tar.gz

RUN mkdir -p /usr/local/startup/scripts
RUN mkdir -p /usr/local/startup/conf.d
COPY *.bash /usr/local/startup/scripts/
COPY prosody.cfg.lua /usr/local/startup/prosody.cfg.lua
COPY conf.d/*.cfg.lua /usr/local/startup/conf.d/

# Prosody automatically builds into the default directory
# which will get overwritten by cloudron, so move it
RUN mv /app/data/* /usr/local/startup/

RUN mv tip.tar.gz /usr/local/startup/tip.tar.gz

# Workaround for hard-coded prosody user and Cloudron user perms
# Make the prosody user the same UID as Cloudron
RUN sudo adduser --disabled-login prosody -gecos 'prosody' && passwd -d prosody

ENTRYPOINT ["/entrypoint.bash"]
# CMD ["prosody", "-F"]