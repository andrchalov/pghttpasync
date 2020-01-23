FROM alpine:edge

RUN apk add --no-cache --virtual .build-deps \
  build-base \
  python3-dev \
  postgresql-dev

RUN apk -U --no-cache add \
  python3 \
  postgresql-libs \
  su-exec && \
  rm -rf /var/cache/*

ADD requirements.txt /opt/requirements.txt
RUN pip3 install -r /opt/requirements.txt

RUN apk del .build-deps

COPY ./src /opt/app

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["python3", "-u", "main.py"]
