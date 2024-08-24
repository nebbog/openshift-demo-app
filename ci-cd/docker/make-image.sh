#!/usr/bin/env bash


set -e

printf "\n\nMaking Project Docker Image...\n\n"

#set +x
set -x

CWD=`pwd`

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#set -x

cd "${SCRIPT_DIR}"

#set +x

source ../lib-common.sh

echo "Making DEMO_APP ${VERSION} Image..."

oc new-build --name demo-app --binary --strategy docker -o yaml | oc apply -f -
oc start-build demo-app --from-dir=. --follow --wait
#oc tag ${DEMO_APP_DCR_REPOSITORY_NAME} ${DEMO_APP_DCR_REPOSITORY_NAME}:${VERSION}

cd "${CWD}"

