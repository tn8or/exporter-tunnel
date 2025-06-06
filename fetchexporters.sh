#!/bin/sh
source /app/vars.sh
for ARCH in "amd64" "arm64" "armv7"; do
  echo "Fetching exporter for ARCHitecture: $ARCH"
  wget -nc "https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-$ARCH.tar.gz" -O "exporters/node_exporter-$VERSION.linux-$ARCH.tar.gz"
  tar -xzkf exporters/node_exporter-$VERSION.linux-$ARCH.tar.gz -C exporters/
done