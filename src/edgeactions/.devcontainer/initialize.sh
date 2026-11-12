#!/bin/sh
# Runs inside a probe container (see initializeCommand) with the Docker host's
# /dev mounted at /host-dev. Prints docker-compose.override.yml to stdout.

if [ -c /host-dev/kvm ]; then
  echo "KVM detected on Docker host, enabling KVM for EdgeActions..." >&2
  cat <<'EOF'
services:
  devcontainer:
    devices:
      - /dev/kvm
    environment:
      DEVICE: /dev/kvm
EOF
else
  cat >&2 <<'WARNING'

========================================================================
  WARNING: KVM NOT DETECTED
========================================================================
  /dev/kvm is not available on the Docker host.

  EdgeActions test commands will NOT work without KVM.
========================================================================

WARNING
  # Empty override (required since dockerComposeFile references it)
  echo "services: {}"
fi
