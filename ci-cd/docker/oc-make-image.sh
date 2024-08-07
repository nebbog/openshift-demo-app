#!/usr/bin/env bash


set -e

printf "\n\nMake APP Docker Image...\n\n"

#set +x
set -x

CWD=`pwd`

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#set -x

cd "${SCRIPT_DIR}"

oc start-build ${DEMO_APP_DCR_REPOSITORY_NAME}:${DEMO_APP_VERSION} --from=.

cd "${CWD}"
