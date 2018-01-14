FROM debian:jessie
# Git branch to build from
ARG BV_TURN=master
# use --build-arg REBUILD=$(date) to invalidate the cache and upgrade all
# packages
ARG REBUILD=0

VOLUME ["/data"]

# https://github.com/python-pillow/Pillow/issues/1763
ENV LIBRARY_PATH=/lib:/usr/lib

# user configuration
ENV MATRIX_UID=991 MATRIX_GID=991

RUN set -ex \
    mkdir /uploads;\
    export DEBIAN_FRONTEND=noninteractive;\
    mkdir -p /var/cache/apt/archives;\
    touch /var/cache/apt/archives/lock;\
    apt-get clean;\
    apt-get update -y;\
    apt-get install -y\
        bash \
        curl postgresql-client\
        coreutils \
        coturn \
        file \
        gcc \
        git \
        libevent-2.0-5 \
        libevent-dev \
        libffi-dev \
        libffi6 \
        libgnutls28-dev \
        libjpeg62-turbo \
        libjpeg62-turbo-dev \
        libldap-2.4-2 \
        libldap2-dev \
        libsasl2-dev \
        libsqlite3-dev \
        libssl-dev \
        libssl1.0.0 \
        libtool \
        libxml2 \
        libxml2-dev \
        libxslt1-dev \
        libxslt1.1 \
        linux-headers-amd64 \
        make \
        pwgen \
        python \
        python-dev \
        python-pip \
        python-psycopg2 \
        python-virtualenv \
        sqlite \
        zlib1g \
        zlib1g-dev
RUN set -ex;\
    :;\
    git clone --branch $BV_TURN --depth 1 https://github.com/coturn/coturn.git /turnbuild ;\
    cd /turnbuild\
    GIT_TURN=$(git ls-remote https://github.com/coturn/coturn.git $BV_TURN | cut -f 1)\
    ./configure;make;make install;\
    echo "coturn: $BV_TURN ($GIT_TURN)" >> /coturn.version;\
    cd /;\
    rm -rf /turnbuild;\
    :;\
    apt-get autoremove -y \
        file \
        gcc \
        git \
        libevent-dev \
        libffi-dev \
        libjpeg62-turbo-dev \
        libldap2-dev \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        libxml2-dev \
        libxslt1-dev \
        linux-headers-amd64 \
        make \
        python-dev \
        zlib1g-dev \
    :;\
    apt-get remove -y coturn;\
    apt-get autoremove -y ;\
    rm -rf /var/lib/apt/* /var/cache/apt/*

# install homerserver template
COPY adds/start.sh /start.sh

# add supervisor configs
COPY adds/supervisord-turnserver.conf /conf/
COPY adds/supervisord.conf /

# startup configuration
ENTRYPOINT ["/start.sh"]
CMD ["start"]
