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

echo "Pushing DEMO-APP ${DEMO_APP_VERSION} Image to Docker Container Registry..."

set -x

docker tag ${DEMO_APP_DCR_REPOSITORY_NAME}:${DEMO_APP_VERSION} ${DCR_CONTAINER_REGISTRY}/${DEMO_APP_DCR_REPOSITORY_NAME}:${DEMO_APP_VERSION}
docker push ${DCR_CONTAINER_REGISTRY}/${DEMO_APP_DCR_REPOSITORY_NAME}:${DEMO_APP_VERSION}

cd "${CWD}"
