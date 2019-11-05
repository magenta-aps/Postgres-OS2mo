FROM postgres:9.6.15

LABEL org.opencontainers.image.title="Postgres OS2mo" \
  org.opencontainers.image.description="A docker image containing postgres and the extensions LoRA and OS2mo needs." \
  org.opencontainers.image.vendor="Magenta ApS" \
  org.opencontainers.image.licenses="MPL-2.0" \
  org.opencontainers.image.source="https://git.magenta.dk/rammearkitektur/postgres-os2mo"


# The official postgres image silently disable auth if there is no
# POSTGRES_PASSWORD set. We don't need the `postgres` user, so we generate a
# random password. This is a workaround for
# https://github.com/docker-library/postgres/issues/580 and can be removed if it
# is fixed upstream.
#
# The workaround is to install pwgen and wrap docker-entrypoint.sh.
RUN apt-get update && apt-get install -y --no-install-recommends \
  pwgen \
  && rm -rf /var/lib/apt/lists/*
COPY docker-entrypoint-wrapper.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint-wrapper.sh"]
# CMD is reset when we overwrite the ENTRYPOINT. We set it here again.
CMD ["postgres"]
# End of workaround

COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
