FROM alpine:latest
LABEL maintainer="Tommy Eriksen <t@tommyeriksen.dk>"
LABEL description="SSH into various devices around the house; provide an ssh tunnel to a prometehus exporter"
# fetch the different versions of exporter
RUN mkdir -p /exporters /app
COPY fetchexporters.sh /exporters/fetchexporters.sh
COPY vars.sh /app/vars.sh
RUN chmod +x /exporters/fetchexporters.sh
RUN /exporters/fetchexporters.sh
RUN apk add --no-cache openssh-client
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["sh","/app/entrypoint.sh"]
