
FROM alpine:3.11

RUN apk add --no-cache ca-certificates   bash curl

COPY entrypoint.sh /entrypoint.sh
COPY templates /
ENTRYPOINT ["/entrypoint.sh"]
