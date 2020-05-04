
FROM alpine:3.11

RUN apk add --no-cache ca-certificates bash curl jq

COPY entrypoint.sh /entrypoint.sh
COPY templates /templates
ENTRYPOINT ["/entrypoint.sh"]
