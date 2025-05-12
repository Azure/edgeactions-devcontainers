#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "Check edgeaction command" edgeaction --version

# Report result
reportResults