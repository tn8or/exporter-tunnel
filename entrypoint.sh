#!/bin/sh
source /app/vars.sh
cp -f /app/sshkey/id_rsa /tmp/id_rsa
chmod 400 /tmp/id_rsa
ARCH=`ssh ${SSHVARS} ${DEST} uname -m`
# Determine the architecture and set the variable accordingly
# Check if the architecture is supported and set the variable
if [ -z "$ARCH" ]; then
  echo "Failed to determine architecture."
  exit 1
fi
# Convert architecture to a common format
if [ -z "$HOSTIP" ]; then
  echo "HOSTIP is not set. Please set the HOSTIP environment variable."
  exit 1
fi
if [ "$ARCH" = "x86_64" ]; then
  ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]; then
  ARCH="arm64"
elif [ "$ARCH" = "armv7l" ]; then
  ARCH="armv7"
else
  echo "Unsupported architecture: $ARCH"
fi

echo "Using exporter for architecture: $ARCH in version $VERSION"

ssh ${SSHVARS} ${DEST} rm -rf /var/tmp/node_exporter
cat /exporters/node_exporter-$VERSION.linux-$ARCH/node_exporter |ssh ${SSHVARS} ${DEST} "mkdir -p /var/tmp/node_exporter && cat > /var/tmp/node_exporter/node_exporter"
ssh ${SSHVARS} ${DEST} "chmod +x /var/tmp/node_exporter/node_exporter && /var/tmp/node_exporter/node_exporter --version && killall node_exporter || true"

ssh ${SSHVARS} -L 0.0.0.0:9100:127.0.0.1:9191 ${DEST} /var/tmp/node_exporter/node_exporter --web.listen-address="127.0.0.1:9191"
