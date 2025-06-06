FROM alpine:latest
LABEL maintainer="Tommy Eriksen <t@tommyeriksen.dk>"
LABEL description="SSH into various devices around the house; provide an ssh tunnel to a prometehus exporter"
# fetch the different versions of exporter
RUN mkdir -p /exporters /app
COPY fetchexporters.sh /exporters/fetchexporters.sh
COPY vars.sh /app/vars.sh
RUN chmod +x /exporters/fetchexporters.sh
RUN /exporters/fetchexporters.sh
RUN apk add --no-cache openssh-client curl
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["sh","/app/entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=3s --retries=1 --start-period=5s --start-interval=5s CMD curl --fail http://localhost:9100 || exit 1