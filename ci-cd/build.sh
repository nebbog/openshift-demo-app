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

    echo "infrastructure is required"
    usage
    exit 1
fi

if [[ -z "$env" ]]; then

    echo "environment is required"
    usage
    exit 1
fi

if [[ -z "$branchToBuild" ]]; then

    echo "branch is required"
    usage
    exit 1
fi

set +x

# runs git fetch.
function gitFetch() {

    local repo=$(git config --get remote.origin.url)

    echo "git fetch from repo: ${repo}"

    git fetch

    RET=$?

    if [ $RET -ne 0 ];then
        logError "Failed to fetch branches"
        exit 1
    fi
}

# runs git checkout
function gitCheckout() {

    local branch=${1}

    echo "Checking out  ${branch}"

    git checkout ${branch}

    RET=$?

    if [ $RET -ne 0 ];then
        logError "Failed to checkout ${branch}"
        exit 1
    fi
}

# runs git pull
function gitPull() {

    local branch=${1}

    echo "Pulling from ${branch}"

    git pull origin ${branch}

    RET=$?

    if [ $RET -ne 0 ];then
        logError "Failed to pull from  ${branch}"
        exit 1
    fi
}

echo "Fetching recent changes"
gitFetch

gitCheckout "main"
gitPull "main"

gitCheckout "$branchToBuild"
gitPull "$branchToBuild"

source lib-common.sh

echo "Building DEMO_APP ${DEMO_APP_VERSION}..."

CWD=`pwd`

#set -x

cd ../

rm -f build/libs/*.jar

./gradlew build --refresh-dependencies -x test

cd "$CWD"

