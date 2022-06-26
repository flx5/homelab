FROM duplicati/duplicati

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        mariadb-client \
    ; \
    rm -rf /var/lib/apt/lists/*