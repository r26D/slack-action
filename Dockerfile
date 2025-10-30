
FROM alpine:3.22.2
LABEL org.opencontainers.image.source=https://github.com/r26D/slack-action
LABEL org.opencontainers.image.description="This action makes it easy to send a Slack WebHook Message"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.authors="r26D, LLC"
LABEL org.opencontainers.image.vendor="r26D, LLC"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.url="https://github.com/r26D/slack-action"
LABEL org.opencontainers.image.documentation="https://github.com/r26D/slack-action"
RUN apk add --no-cache ca-certificates bash curl jq

COPY entrypoint.sh /entrypoint.sh
COPY templates /templates
ENTRYPOINT ["/entrypoint.sh"]
