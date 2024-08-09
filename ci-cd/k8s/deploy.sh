#!/usr/bin/env bash

usage() { echo "Usage: $0 -i <infrastructure> -e <environment>" 1>&2; exit 1; }

set -e

declare inf=""
declare env=""


# Initialize parameters specified from command line
while getopts ":c:e:i:m:" arg; do
        case "${arg}" in
                i)
                        inf=${OPTARG}
                        ;;
                e)
                        env=${OPTARG}
                        ;;
        esac
done
shift $((OPTIND-1))


if [[ -z "$inf" ]]; then

   inf="prod"

fi

if [[ -z "$env" ]]; then

   env="prod"

fi

#set +x
#set -e
set -x
#Export environment variables
source  ../env/${env}/.env

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

#set -e
#set +x

/tmp/helm template ./helm \
    -f "${ENV_CONFIG}" \
    --set image.tag="${VERSION}" \
    --namespace "${NAMESPACE}" \
    | oc apply --namespace "${NAMESPACE}" -f -
    #| kubectl apply --namespace "${NAMESPACE}" -f - -o yaml --dry-run=client

#set +e

cd "${CWD}"

