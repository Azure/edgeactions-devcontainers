#!/bin/bash
TEMPLATE_ID="$1"
set -e

SRC_DIR="/tmp/${TEMPLATE_ID}"
echo "Running Smoke Test"

ID_LABEL="test-container=${TEMPLATE_ID}"
devcontainer exec --workspace-folder "${SRC_DIR}" --id-label ${ID_LABEL} /bin/sh -c 'set -e && if [ -f "test-project/test.sh" ]; then cd test-project && if [ "$(id -u)" = "0" ]; then chmod +x test.sh; else sudo chmod +x test.sh; fi && ./test.sh; else ls -a; fi'

if [ "${TEMPLATE_ID}" = "edgeactions" ]; then
    if [ -c /dev/kvm ]; then
        echo "Host has /dev/kvm, checking passthrough"
        devcontainer exec --workspace-folder "${SRC_DIR}" --id-label ${ID_LABEL} test -c /dev/kvm
    else
        echo "Host has no /dev/kvm, checking it is not passed through"
        devcontainer exec --workspace-folder "${SRC_DIR}" --id-label ${ID_LABEL} sh -c '! test -e /dev/kvm'
    fi
fi
# Clean up
docker rm -f $(docker container ls -f "label=${ID_LABEL}" -q)
rm -rf "${SRC_DIR}"
