#!/bin/bash

USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}

if [ ! -d "/home/user" ]; then
  addgroup --gid $GROUP_ID usergrp
  adduser --gecos "" --shell /bin/sh --home /home/user --uid $USER_ID --disabled-password --ingroup usergrp user
fi

export HOME=/home/user

until psql -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - continue"

if [ -z "$NO_DEPLOY_DB" ] || [ "$NO_DEPLOY_DB" = false ]; then
  cd /sql;
  psql -qt -v pgver_schema="$DB_SCHEMA" -1f /sql/pgver.sql || exit 1
fi

cd /opt/app
exec gosu user "$@"
