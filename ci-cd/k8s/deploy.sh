#!/usr/bin/env bash

set -e
set -x
printf "\n\nDeploying Project...\n\n"

CWD=`pwd`

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "${SCRIPT_DIR}"

source ../lib-common.sh

ENV_CONFIG="helm/env/values.yaml"

if [ ! -f "${ENV_CONFIG}" ] ; then

    echo "Environment config file ${ENV_CONFIG} not found"
    exit 1

fi

NAMESPACE=demo-tomcat

#set -e
#set +x

helm template ./helm \
    -f "${ENV_CONFIG}" \
    --set image.tag="${DEMO_APP_VERSION}" \
    --namespace "${NAMESPACE}" \
    | kubectl apply --namespace "${NAMESPACE}" -f - -o yaml --dry-run=client




#set +e

cd "${CWD}"
