#!/usr/bin/env bash
# Detects KVM availability and generates docker-compose.override.yml if present
set -e

OVERRIDE_FILE=".devcontainer/docker-compose.override.yml"

if [ -e /dev/kvm ]; then
  echo "KVM detected, enabling KVM for EdgeActions..."
  cat > "$OVERRIDE_FILE" <<EOF
services:
  devcontainer:
    devices:
      - /dev/kvm
    environment:
      DEVICE: /dev/kvm
EOF
else
  echo ""
  echo "========================================================================"
  echo "  WARNING: KVM NOT DETECTED"
  echo "========================================================================"
  echo "  /dev/kvm is not available on this machine."
  echo ""
  echo "  EdgeActions test commands will NOT work without KVM."
  echo "========================================================================"
  echo ""
  # Create empty override (required since dockerComposeFile references it)
  echo "services: {}" > "$OVERRIDE_FILE"
EOF
fi
