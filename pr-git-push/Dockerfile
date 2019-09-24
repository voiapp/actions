FROM eu.gcr.io/voi-stage/builder:7.2

RUN apk update && \
    apk add --no-cache --update jq

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
