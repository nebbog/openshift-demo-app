#!/usr/bin/env bash


set -e

printf "\n\nPreparing APP for Docker Image...\n\n"

#set +x
set -x

CWD=`pwd`

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#set -x

cd "${SCRIPT_DIR}"

#set +x

source ../lib-common.sh

echo "Preparing DEMO_APP ${DEMO_APP_VERSION} for Docker Image..."

DEMO_APP_WAR_BUILD_PATH=../../build/libs/demo-app.war

if [[ ! -f "$DEMO_APP_WAR_BUILD_PATH" ]]; then
    echo "Error: Unable to find DEMO_APP WAR File ${DEMO_APP_WAR_BUILD_PATH}. Did you forget to build the project?"
    exit 1
fi

if [ -d target ] ; then
  rm -fr target
fi

set -x

mkdir target

cp "${DEMO_APP_WAR_BUILD_PATH}" target/.

mkdir target/demo-app

cd target/demo-app

jar -xvf ../demo-app.war

cd "${SCRIPT_DIR}"

rm target/demo-app.war

cd "${CWD}"
