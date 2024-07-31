#!/usr/bin/env bash

set -x
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

# version update
function gitVersionUpdate() {

    type_of_version=${1}
    major=0
    minor=0
    build=0
    patch=0
    set -e

    VERSION_FILE=src/version.properties

    VERSION=$(grep 'version=' ${VERSION_FILE} | cut -d'=' -f2)

    if [[ -z "$VERSION" ]]; then

        logError "Unable to determine version number"
        exit 1

    fi

    # break down the version number into it's components
    regex="([0-9]+).([0-9]+).([0-9]+).([0-9]+)"
    if [[ $VERSION =~ $regex ]]; then
      major="${BASH_REMATCH[1]}"
      minor="${BASH_REMATCH[2]}"
      patch="${BASH_REMATCH[3]}"
      build="${BASH_REMATCH[4]}"
    fi

    case "${type_of_version}" in
        major)
        major=$((major + 1 ))
        ;;
        minor)
        minor=$((minor + 1 ))
        patch=0
        build=0
        ;;
        patch)
        patch=$((patch + 1 ))
        build=0
        ;;
        build)
        build=$((build + 1 ))
        ;;
        *)
        echo "usage: gitVersionUpdates [major/minor/patch/build]"
        usage
        ;;
    esac

    NEW_VERSION="${major}.${minor}.${patch}.${build}"

    echo "version=${NEW_VERSION}" > ${VERSION_FILE}

    echo "build.date=`date -u '+%Y-%m-%d_%X'`" >> ${VERSION_FILE}

    cat ${VERSION_FILE}

    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

    set -x

    git add ${VERSION_FILE}

    RET=$?

    if [ $RET -ne 0 ];then
        logError "Failed to add ${VERSION_FILE}"
        exit 1
    fi

    git commit -m "Updated version to ${NEW_VERSION}"

    RET=$?

    if [ $RET -ne 0 ];then
        logError "Failed to commit ${VERSION_FILE}"
        exit 1
    fi

    git pull origin ${BRANCH_NAME}

    RET=$?

    if [ $RET -ne 0 ];then
        logError "Failed to pull from ${BRANCH_NAME}"
        exit 1
    fi

    git push origin ${BRANCH_NAME}

    RET=$?

    if [ $RET -ne 0 ];then
        logError "Failed to push to ${BRANCH_NAME}"
        exit 1
    fi

    export VERSION=$(grep 'version=' ${VERSION_FILE} | cut -d'=' -f2)
}
