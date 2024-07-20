#!/usr/bin/env bash

usage() { echo "Usage: $0" 1>&2; exit 1; }

set -e
set -x

printf "\n\nBuilding Project...\n\n"

#set +x
set -e

source lib-common.sh

echo "Building DEMO_APP ${DEMO_APP_VERSION}..."

CWD=`pwd`

#set -x

cd ../

rm -f build/libs/*.jar

./gradlew build --refresh-dependencies -x test

cd "$CWD"
