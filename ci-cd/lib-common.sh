#!/usr/bin/env bash


DCR_CONTAINER_REGISTRY=localhost:30100
DEMO_APP_DCR_REPOSITORY_NAME=demo-app

#set +x
set -x

COMMON_CWD=`pwd`
COMMON_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${COMMON_SCRIPT_DIR}

VERSION_FILE_PATH=../src/version.properties

if [[ -z "${DEMO_APP_VERSION}" ]]; then

    export DEMO_APP_VERSION=`cat ${VERSION_FILE_PATH}  | grep 'version=' | cut -d '=' -f 2`

    if [[ -z "$VERSION_FILE_PATH" ]]; then
        echo "Error: Unable to determine DEMO_APP's Version Using: ${VERSION_FILE_PATH}"
        exit 1
    fi

fi

#DCR_HELPER_LIB_PATH=../../infrastucture-ci-cd/bash/lib-dcr-helper.sh

#if [[ ! -f "${DCR_HELPER_LIB_PATH}" ]]; then
#    echo "Error: DCR Helper File ${DCR_HELPER_LIB_PATH} not found. Did you forget to checkout the helper project?"
#    exit 1
#fi

#source "${DCR_HELPER_LIB_PATH}"

cd "${COMMON_CWD}"
