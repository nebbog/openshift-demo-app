#!/usr/bin/env bash

usage() { echo "Usage: $0  -i <infrastructure> -e <environment> -b <branchToBuild - hotfix/develop>" 1>&2; exit 1; }

set -e
set -x

declare inf=""
declare env=""
declare branchToBuild=""
# Initialize parameters specified from command line
while getopts ":c:e:i:b:m:" arg; do
        case "${arg}" in
                i)
                        inf=${OPTARG}
                        ;;
                e)
                        env=${OPTARG}
                        ;;
                b)
                  branchToBuild=${OPTARG}
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

if [[ -z "$branchToBuild" ]]; then

     branchToBuild="patch"
fi

#set +x

source env/${env}/.env
source env/.env

source git-helper.sh

echo "Fetching recent changes"
gitFetch

gitCheckout "main"
gitPull "main"

gitCheckout "$branchToBuild"
gitPull "$branchToBuild"

source lib-common.sh

if [ "$branchToBuild" = "prod" ]; then

    gitVersionUpdate "patch"

elif [ "$branchToBuild" = "develop" ]; then

    gitVersionUpdate "develop"
fi


echo "Building DEMO_APP ${VERSION}..."

CWD=`pwd`

#set -x

cd ../

rm -f build/libs/*.jar

./gradlew build --refresh-dependencies -x test

cd "$CWD"
